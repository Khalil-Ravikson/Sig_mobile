import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/mock/fonte_json.dart';
import '../domain/frequencia_repository.dart';
import '../domain/frequencia_resumo.dart';
import '../domain/pagina_aulas.dart';
import 'frequencia_dto.dart';
import 'turma_mapper.dart';

final _idValido = RegExp(r'^[a-z0-9_-]{1,40}$');

/// Frequência lida de `assets/mock/frequencia_<id>.json` (alpha). O arquivo
/// é lido uma vez (cache do `FonteJson`); as páginas são fatias dele.
class JsonFrequenciaRepository implements FrequenciaRepository {
  const JsonFrequenciaRepository(this._fonte);

  final FonteJson _fonte;

  Future<FrequenciaDto> _ler(String turmaId) async {
    final json = await _fonte.ler('frequencia_$turmaId.json');
    return FrequenciaDto.fromJson(json! as Map<String, dynamic>);
  }

  Future<Result<T>> _proteger<T>(
    String turmaId,
    T Function(FrequenciaDto dto) montar,
  ) async {
    if (!_idValido.hasMatch(turmaId)) return const Falha(NaoEncontrado());
    try {
      return Sucesso(montar(await _ler(turmaId)));
    } on FlutterError {
      return const Falha(NaoEncontrado());
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }

  @override
  Future<Result<FrequenciaResumo>> carregarResumo(String turmaId) =>
      _proteger(turmaId, TurmaMapper.resumo);

  @override
  Future<Result<PaginaAulas>> carregarAulas(
    String turmaId, {
    int pagina = 0,
    int tamanho = 20,
  }) => _proteger(turmaId, (dto) {
    final dias = TurmaMapper.dias(dto);
    final inicio = math.min(math.max(pagina, 0) * tamanho, dias.length);
    final fim = math.min(inicio + tamanho, dias.length);
    return PaginaAulas(
      itens: dias.sublist(inicio, fim),
      temMais: fim < dias.length,
    );
  });
}
