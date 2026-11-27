import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/mock/fonte_json.dart';
import '../domain/aluno.dart';
import '../domain/aluno_repository.dart';
import 'aluno_dto.dart';
import 'aluno_mapper.dart';

/// Dados do discente lidos de `assets/mock/aluno.json` (alpha).
class JsonAlunoRepository implements AlunoRepository {
  const JsonAlunoRepository(this._fonte);

  final FonteJson _fonte;

  @override
  Future<Result<Aluno>> carregarAluno() async {
    try {
      final json = await _fonte.ler('aluno.json');
      final dto = AlunoDto.fromJson(json! as Map<String, dynamic>);
      return Sucesso(AlunoMapper.aluno(dto));
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }
}
