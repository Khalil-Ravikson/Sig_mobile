import 'package:flutter/foundation.dart';

import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/mock/fonte_json.dart';
import '../domain/turma_detalhe.dart';
import '../domain/turma_repository.dart';
import 'turma_detalhe_dto.dart';
import 'turma_mapper.dart';

/// Só letras minúsculas, números, `_` e `-`: o id da URL vira nome de arquivo.
final _idValido = RegExp(r'^[a-z0-9_-]{1,40}$');

/// Detalhe da turma lido de `assets/mock/turma_<id>.json` (alpha).
class JsonTurmaRepository implements TurmaRepository {
  const JsonTurmaRepository(this._fonte);

  final FonteJson _fonte;

  @override
  Future<Result<TurmaDetalhe>> carregarTurma(String id) async {
    if (!_idValido.hasMatch(id)) return const Falha(NaoEncontrado());
    try {
      final json = await _fonte.ler('turma_$id.json');
      final dto = TurmaDetalheDto.fromJson(json! as Map<String, dynamic>);
      return Sucesso(TurmaMapper.detalhe(dto));
    } on FlutterError {
      // Asset inexistente: turma que o "servidor" não conhece.
      return const Falha(NaoEncontrado());
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }
}
