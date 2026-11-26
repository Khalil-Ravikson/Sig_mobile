import '../domain/documento.dart';
import 'documentos_dto.dart';

/// Isola o formato do JSON (ou da API) do modelo do app. Valor desconhecido
/// cai no caso mais cauteloso (nunca promete um PDF que talvez não exista).
class DocumentosMapper {
  const DocumentosMapper._();

  static List<Documento> documentos(DocumentosDto dto) => dto.itens
      .map(
        (d) => Documento(
          id: d.id,
          titulo: d.titulo,
          subtitulo: d.subtitulo,
          tipo: switch (d.tipo) {
            'doc' => TipoDocumento.doc,
            _ => TipoDocumento.pdf,
          },
          grupo: switch (d.grupo) {
            'mais_usados' => GrupoDocumento.maisUsados,
            _ => GrupoDocumento.declaracoes,
          },
          estado: switch (d.estado) {
            'disponivel' => EstadoDocumento.disponivel,
            _ => EstadoDocumento.sobPedido,
          },
        ),
      )
      .toList();
}
