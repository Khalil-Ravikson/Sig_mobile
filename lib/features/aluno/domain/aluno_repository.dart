import '../../../core/error/result.dart';
import 'aluno.dart';

abstract interface class AlunoRepository {
  Future<Result<Aluno>> carregarAluno();
}
