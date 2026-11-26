import '../../../core/error/result.dart';
import 'ajuda.dart';

abstract interface class AjudaRepository {
  Future<Result<Ajuda>> carregarAjuda();
}
