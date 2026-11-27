import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/mock/fonte_json.dart';
import '../domain/resumo_semestre.dart';
import '../domain/semestre_repository.dart';
import 'resumo_semestre_dto.dart';
import 'semestre_mapper.dart';

/// Resumo do semestre lido de `assets/mock/turmas.json` (alpha). Um arquivo,
/// uma leitura: Início e Turmas usam o mesmo carregamento.
class JsonSemestreRepository implements SemestreRepository {
  const JsonSemestreRepository(this._fonte);

  final FonteJson _fonte;

  static const _arquivo = 'turmas.json';

  @override
  Future<Result<ResumoSemestre>> carregarResumo() async {
    try {
      final json = await _fonte.ler(_arquivo);
      final dto = ResumoSemestreDto.fromJson(json! as Map<String, dynamic>);
      return Sucesso(SemestreMapper.resumo(dto));
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }
}
