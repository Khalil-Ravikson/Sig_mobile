import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../../core/util/formato_data.dart';
import '../domain/aula_dia.dart';
import '../domain/frequencia_resumo.dart';
import 'turma_providers.dart';

part 'frequencia_view_model.g.dart';

/// Quantos dias de aula cada página traz.
const tamanhoPaginaFrequencia = 20;

/// Dias de aula de um mês, para o cartão "Setembro".
class GrupoMes {
  const GrupoMes({required this.titulo, required this.dias});

  final String titulo;
  final List<AulaDia> dias;
}

/// Agrupa dias (já em ordem) por mês, mantendo a ordem.
List<GrupoMes> agruparPorMes(List<AulaDia> dias) {
  final grupos = <GrupoMes>[];
  int? chave;
  for (final dia in dias) {
    final k = dia.data.year * 12 + dia.data.month;
    if (k != chave) {
      grupos.add(GrupoMes(titulo: FormatoData.nomeMes(dia.data), dias: []));
      chave = k;
    }
    grupos.last.dias.add(dia);
  }
  return grupos;
}

class FrequenciaUi {
  const FrequenciaUi({
    required this.resumo,
    required this.dias,
    required this.temMais,
    this.carregandoMais = false,
    this.falhouAoCarregarMais = false,
  });

  final FrequenciaResumo resumo;

  /// Dias já carregados, mais recentes primeiro.
  final List<AulaDia> dias;
  final bool temMais;
  final bool carregandoMais;
  final bool falhouAoCarregarMais;

  List<GrupoMes> get grupos => agruparPorMes(dias);

  FrequenciaUi copyWith({
    List<AulaDia>? dias,
    bool? temMais,
    bool? carregandoMais,
    bool? falhouAoCarregarMais,
  }) => FrequenciaUi(
    resumo: resumo,
    dias: dias ?? this.dias,
    temMais: temMais ?? this.temMais,
    carregandoMais: carregandoMais ?? this.carregandoMais,
    falhouAoCarregarMais: falhouAoCarregarMais ?? this.falhouAoCarregarMais,
  );
}

/// Mapa de frequência com rolagem infinita simulada: o resumo (totais e
/// pontos) vem inteiro; a lista por dia, 20 por vez.
@riverpod
class FrequenciaViewModel extends _$FrequenciaViewModel {
  @override
  Future<FrequenciaUi> build(String turmaId) async {
    final repositorio = ref.watch(frequenciaRepositoryProvider);
    final pedidoResumo = repositorio.carregarResumo(turmaId);
    final pedidoPagina = repositorio.carregarAulas(
      turmaId,
      tamanho: tamanhoPaginaFrequencia,
    );
    final resumo = switch (await pedidoResumo) {
      Sucesso(:final dado) => dado,
      Falha(:final erro) => throw erro,
    };
    final pagina = switch (await pedidoPagina) {
      Sucesso(:final dado) => dado,
      Falha(:final erro) => throw erro,
    };
    return FrequenciaUi(
      resumo: resumo,
      dias: pagina.itens,
      temMais: pagina.temMais,
    );
  }

  /// Traz a próxima página. Ignora chamadas enquanto já está carregando ou
  /// quando não há mais nada.
  Future<void> carregarMais() async {
    final atual = state.value;
    if (atual == null || !atual.temMais || atual.carregandoMais) return;

    state = AsyncData(
      atual.copyWith(carregandoMais: true, falhouAoCarregarMais: false),
    );
    final proxima = atual.dias.length ~/ tamanhoPaginaFrequencia;
    final resultado = await ref
        .read(frequenciaRepositoryProvider)
        .carregarAulas(
          turmaId,
          pagina: proxima,
          tamanho: tamanhoPaginaFrequencia,
        );
    if (!ref.mounted) return;

    state = AsyncData(switch (resultado) {
      Sucesso(:final dado) => atual.copyWith(
        dias: [...atual.dias, ...dado.itens],
        temMais: dado.temMais,
        carregandoMais: false,
        falhouAoCarregarMais: false,
      ),
      Falha() => atual.copyWith(
        carregandoMais: false,
        falhouAoCarregarMais: true,
      ),
    });
  }
}
