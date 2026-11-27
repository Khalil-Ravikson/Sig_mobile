import '../../../core/error/result.dart';
import 'documento.dart';

abstract interface class DocumentosRepository {
  Future<Result<List<Documento>>> carregarDocumentos();
}
