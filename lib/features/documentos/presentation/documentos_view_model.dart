import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../../core/util/debouncer.dart';
import '../../../core/util/texto.dart';
import '../../auth/presentation/sessao_provider.dart';
import '../domain/documento.dart';
import 'documentos_providers.dart';

part 'documentos_view_model.g.dart';

/// Um documento pronto para exibir.
class DocumentoUi {
  const DocumentoUi({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.tipo,
    required this.estado,
    required this.comBotaoBaixar,
  });

  final String id;
  final String titulo;
  final String subtitulo;

  /// `PDF` ou `DOC`.
  final String tipo;
  final EstadoDocumento estado;

  /// "Baixar" nos mais usados; nas declarações aparece o selo de estado.
  final bool comBotaoBaixar;
}

class GrupoDocumentosUi {
  const GrupoDocumentosUi({required this.titulo, required this.itens});

  final String titulo;
  final List<DocumentoUi> itens;
}

class DocumentosUi {
  const DocumentosUi({required this.grupos, required this.consulta});

  final List<GrupoDocumentosUi> grupos;

  /// O texto da busca já aplicado (vazio = sem busca).
  final String consulta;

  bool get semResultado => grupos.isEmpty;
}

/// Todos os documentos (uma leitura, sem filtro).
@Riverpod(keepAlive: true)
Future<List<Documento>> documentos(Ref ref) async {
  ref.watch(sessaoProvider.select((s) => s.vinculo?.id));
  final resultado = await ref
      .watch(documentosRepositoryProvider)
      .carregarDocumentos();
  return switch (resultado) {
    Sucesso(:final dado) => dado,
    Falha(:final erro) => throw erro,
  };
}

/// O texto da busca já "assentado": só muda 300 ms depois da última tecla.
@riverpod
class ConsultaDocumentos extends _$ConsultaDocumentos {
  late final _debouncer = Debouncer();

  @override
  String build() {
    ref.onDispose(_debouncer.cancelar);
    return '';
  }

  /// Chamado a cada tecla; aplica depois de 300 ms parado.
  void digitar(String texto) {
    _debouncer.executar(() {
      if (ref.mounted) state = texto.trim();
    });
  }

  /// Limpar vale na hora, sem esperar.
  void limpar() {
    _debouncer.cancelar();
    state = '';
  }
}

/// Documentos filtrados pela busca e agrupados, prontos para a tela.
@riverpod
Future<DocumentosUi> documentosVisiveis(Ref ref) async {
  final todos = await ref.watch(documentosProvider.future);
  final consulta = ref.watch(consultaDocumentosProvider);
  final termo = normalizarParaBusca(consulta);

  bool casa(Documento d) =>
      termo.isEmpty ||
      normalizarParaBusca('${d.titulo} ${d.subtitulo}').contains(termo);

  List<DocumentoUi> doGrupo(GrupoDocumento grupo) => [
    for (final d in todos)
      if (d.grupo == grupo && casa(d))
        DocumentoUi(
          id: d.id,
          titulo: d.titulo,
          subtitulo: d.subtitulo,
          tipo: d.tipo == TipoDocumento.doc ? 'DOC' : 'PDF',
          estado: d.estado,
          comBotaoBaixar:
              grupo == GrupoDocumento.maisUsados &&
              d.estado == EstadoDocumento.disponivel,
        ),
  ];

  final grupos = [
    for (final (grupo, titulo) in [
      (GrupoDocumento.maisUsados, 'Mais usados'),
      (GrupoDocumento.declaracoes, 'Declarações e atestados'),
    ])
      if (doGrupo(grupo) case final itens when itens.isNotEmpty)
        GrupoDocumentosUi(titulo: titulo, itens: itens),
  ];
  return DocumentosUi(grupos: grupos, consulta: consulta);
}
