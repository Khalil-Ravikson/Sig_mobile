import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/mock/fonte_json.dart';
import '../domain/ajuda.dart';
import '../domain/ajuda_repository.dart';
import 'ajuda_dto.dart';
import 'ajuda_mapper.dart';

/// Perguntas frequentes e contatos lidos de `assets/mock/ajuda.json` (alpha).
class JsonAjudaRepository implements AjudaRepository {
  const JsonAjudaRepository(this._fonte);

  final FonteJson _fonte;

  @override
  Future<Result<Ajuda>> carregarAjuda() async {
    try {
      final json = await _fonte.ler('ajuda.json');
      final dto = AjudaDto.fromJson(json! as Map<String, dynamic>);
      return Sucesso(AjudaMapper.ajuda(dto));
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }
}
