import '../../../core/error/result.dart';
import 'turma_detalhe.dart';

abstract interface class TurmaRepository {
  Future<Result<TurmaDetalhe>> carregarTurma(String id);
}
