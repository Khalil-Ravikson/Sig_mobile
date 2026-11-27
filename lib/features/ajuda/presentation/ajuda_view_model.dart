import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../../core/util/debouncer.dart';
import '../../../core/util/texto.dart';
import '../domain/ajuda.dart';
import '../domain/ajuda_repository.dart';

part 'ajuda_view_model.g.dart';

/// Sem API ainda: quem usa o app precisa trocar por uma implementação
/// (o alpha faz isso em `main_alpha.dart`).
final ajudaRepositoryProvider = Provider<AjudaRepository>(
  (ref) => throw UnimplementedError(
    'Sem implementação de AjudaRepository: use main_alpha.dart.',
  ),
);

/// Perguntas e contatos (uma leitura, sem filtro).
@Riverpod(keepAlive: true)
Future<Ajuda> ajuda(Ref ref) async {
  final resultado = await ref.watch(ajudaRepositoryProvider).carregarAjuda();
  return switch (resultado) {
    Sucesso(:final dado) => dado,
    Falha(:final erro) => throw erro,
  };
}

/// O texto da busca já "assentado": só muda 300 ms depois da última tecla.
@riverpod
class ConsultaAjuda extends _$ConsultaAjuda {
  late final _debouncer = Debouncer();

  @override
  String build() {
    ref.onDispose(_debouncer.cancelar);
    return '';
  }

  void digitar(String texto) {
    _debouncer.executar(() {
      if (ref.mounted) state = texto.trim();
    });
  }

  /// Limpar vale na hora.
  void limpar() {
    _debouncer.cancelar();
    state = '';
  }
}

class AjudaUi {
  const AjudaUi({
    required this.perguntas,
    required this.contatos,
    required this.consulta,
  });

  final List<PerguntaFrequente> perguntas;
  final List<ContatoAjuda> contatos;
  final String consulta;

  /// Com busca ativa e nenhuma pergunta batendo.
  bool get semResultado => consulta.isNotEmpty && perguntas.isEmpty;
}

/// A busca só filtra as perguntas (os contatos ficam sempre à mão).
@riverpod
Future<AjudaUi> ajudaVisivel(Ref ref) async {
  final ajuda = await ref.watch(ajudaProvider.future);
  final consulta = ref.watch(consultaAjudaProvider);
  final termo = normalizarParaBusca(consulta);
  return AjudaUi(
    perguntas: [
      for (final p in ajuda.perguntas)
        if (termo.isEmpty ||
            normalizarParaBusca('${p.pergunta} ${p.resposta}').contains(termo))
          p,
    ],
    contatos: ajuda.contatos,
    consulta: consulta,
  );
}
