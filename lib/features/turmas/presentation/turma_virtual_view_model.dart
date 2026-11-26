import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/mock/mock_providers.dart';
import '../../../core/util/formato_data.dart';
import '../../../core/util/iniciais.dart';
import '../domain/notas.dart';
import '../domain/turma_detalhe.dart';
import 'resumo_semestre_provider.dart';
import 'turma_providers.dart';

part 'turma_virtual_view_model.g.dart';

/// Célula de nota (N1, N2, N3 ou Média).
class NotaUi {
  const NotaUi({
    required this.rotulo,
    required this.valor,
    this.destaque = false,
    this.lancada = true,
  });

  final String rotulo;
  final String valor;

  /// A média aparece em destaque.
  final bool destaque;

  /// `false` quando a nota ainda não saiu (aparece "—" apagado).
  final bool lancada;
}

class ProximaAvaliacaoUi {
  const ProximaAvaliacaoUi({
    required this.titulo,
    required this.dia,
    required this.mes,
    required this.detalhe,
  });

  final String titulo;
  final String dia;
  final String mes;

  /// `10/12 · 13h10 · em 15 dias`
  final String detalhe;
}

class DocenteUi {
  const DocenteUi({
    required this.nome,
    required this.iniciais,
    required this.email,
  });

  final String nome;
  final String iniciais;
  final String email;
}

/// Tudo o que as abas Resumo e Notas mostram, já formatado.
class TurmaVirtualUi {
  const TurmaVirtualUi({
    required this.id,
    required this.disciplina,
    required this.semestre,
    required this.subtitulo,
    required this.frequenciaPercentual,
    required this.totalAulas,
    required this.totalFaltas,
    required this.limiteFaltas,
    required this.minimoPercentual,
    required this.dentroDoLimite,
    required this.celulasDeNotas,
    required this.detalhesDeNotas,
    required this.proxima,
    required this.docente,
  });

  final String id;
  final String disciplina;
  final String semestre;

  /// `Turma 01 · Seg e qua · 3º e 4º horário`
  final String subtitulo;

  final int frequenciaPercentual;
  final int totalAulas;
  final int totalFaltas;
  final int limiteFaltas;
  final int minimoPercentual;
  final bool dentroDoLimite;

  /// N1, N2, N3 e Média.
  final List<NotaUi> celulasDeNotas;

  /// Nota 1, 2, 3, 2ª chamada, prova final e média (rótulo, valor).
  final List<(String, String)> detalhesDeNotas;
  final ProximaAvaliacaoUi? proxima;
  final DocenteUi docente;

  bool get temAulas => totalAulas > 0;

  /// `2 faltas em 32 aulas`
  String get textoFrequencia {
    if (!temAulas) return 'Ainda sem aulas registradas';
    final faltas = totalFaltas == 1 ? '1 falta' : '$totalFaltas faltas';
    return '$faltas em $totalAulas aulas';
  }
}

/// Turma virtual: junta o resumo da lista, o detalhe e a frequência (as duas
/// leituras de arquivo saem em paralelo e ficam em cache).
@riverpod
Future<TurmaVirtualUi> turmaVirtualViewModel(Ref ref, String id) async {
  final resumo = await ref.watch(resumoSemestreProvider.future);
  final turma = resumo.turmas.where((t) => t.id == id).firstOrNull;
  if (turma == null) throw const NaoEncontrado();

  final hoje = ref.watch(relogioProvider)();
  final pedidoDetalhe = ref.watch(turmaRepositoryProvider).carregarTurma(id);
  final pedidoFrequencia = ref
      .watch(frequenciaRepositoryProvider)
      .carregarResumo(id);
  final detalhe = _ou(await pedidoDetalhe);
  final frequencia = _ou(await pedidoFrequencia);

  return TurmaVirtualUi(
    id: id,
    disciplina: turma.disciplina,
    semestre: resumo.semestre,
    subtitulo: ['Turma ${detalhe.turma}', ?turma.horario].join(' · '),
    frequenciaPercentual: frequencia.percentual,
    totalAulas: frequencia.totalAulas,
    totalFaltas: frequencia.totalFaltas,
    limiteFaltas: frequencia.limiteFaltas,
    minimoPercentual: frequencia.minimoPercentual,
    dentroDoLimite: frequencia.dentroDoLimite,
    celulasDeNotas: _celulas(detalhe.notas),
    detalhesDeNotas: _detalhes(detalhe.notas),
    proxima: _proxima(detalhe, hoje),
    docente: DocenteUi(
      nome: detalhe.docente.nome,
      iniciais: iniciaisDe(detalhe.docente.nome),
      email: detalhe.docente.email,
    ),
  );
}

T _ou<T>(Result<T> resultado) => switch (resultado) {
  Sucesso(:final dado) => dado,
  Falha(:final erro) => throw erro,
};

List<NotaUi> _celulas(Notas n) => [
  _celula('N1', n.n1),
  _celula('N2', n.n2),
  _celula('N3', n.n3),
  _celula('Média', n.media, destaque: true),
];

NotaUi _celula(String rotulo, double? valor, {bool destaque = false}) => NotaUi(
  rotulo: rotulo,
  valor: FormatoData.notaUmaCasa(valor),
  destaque: destaque,
  lancada: valor != null,
);

List<(String, String)> _detalhes(Notas n) => [
  ('Nota 1', FormatoData.notaUmaCasa(n.n1)),
  ('Nota 2', FormatoData.notaUmaCasa(n.n2)),
  ('Nota 3', FormatoData.notaUmaCasa(n.n3)),
  ('2ª chamada', FormatoData.notaUmaCasa(n.segundaChamada)),
  ('Prova final', FormatoData.notaUmaCasa(n.provaFinal)),
  ('Média', FormatoData.notaUmaCasa(n.media)),
];

ProximaAvaliacaoUi? _proxima(TurmaDetalhe detalhe, DateTime hoje) {
  final futuras = detalhe.avaliacoes
      .where((a) => FormatoData.diasAte(a.data, hoje) >= 0)
      .toList();
  if (futuras.isEmpty) return null;
  final a = futuras.first;
  return ProximaAvaliacaoUi(
    titulo: a.descricao,
    dia: FormatoData.dia(a.data),
    mes: FormatoData.mesAbreviado(a.data),
    detalhe: [
      FormatoData.diaMes(a.data),
      ?FormatoData.hora(a.hora),
      FormatoData.minusculaInicial(FormatoData.emDias(a.data, hoje)),
    ].join(' · '),
  );
}
