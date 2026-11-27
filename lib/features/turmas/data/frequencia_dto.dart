import 'package:freezed_annotation/freezed_annotation.dart';

part 'frequencia_dto.freezed.dart';
part 'frequencia_dto.g.dart';

/// Formato de `assets/mock/frequencia_<id>.json`: um item por dia de aula,
/// com `faltas` ausente (ou 0) quando o aluno esteve presente.
@freezed
abstract class AulaDiaDto with _$AulaDiaDto {
  const factory AulaDiaDto({
    required String data,
    required int aulas,
    @Default(0) int faltas,
  }) = _AulaDiaDto;

  factory AulaDiaDto.fromJson(Map<String, dynamic> json) =>
      _$AulaDiaDtoFromJson(json);
}

@freezed
abstract class FrequenciaDto with _$FrequenciaDto {
  const factory FrequenciaDto({
    required int minimoPercentual,
    required List<AulaDiaDto> aulas,
  }) = _FrequenciaDto;

  factory FrequenciaDto.fromJson(Map<String, dynamic> json) =>
      _$FrequenciaDtoFromJson(json);
}
