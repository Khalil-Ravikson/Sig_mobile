import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/mock/fonte_json.dart';
import '../domain/documento.dart';
import '../domain/documentos_repository.dart';
import 'documentos_dto.dart';
import 'documentos_mapper.dart';

/// Lista de documentos lida de `assets/mock/documentos.json` (alpha).
class JsonDocumentosRepository implements DocumentosRepository {
  const JsonDocumentosRepository(this._fonte);

  final FonteJson _fonte;

  @override
  Future<Result<List<Documento>>> carregarDocumentos() async {
    try {
      final json = await _fonte.ler('documentos.json');
      final dto = DocumentosDto.fromJson(json! as Map<String, dynamic>);
      return Sucesso(DocumentosMapper.documentos(dto));
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }
}
