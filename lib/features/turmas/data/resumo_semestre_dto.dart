import 'package:freezed_annotation/freezed_annotation.dart';

part 'resumo_semestre_dto.freezed.dart';
part 'resumo_semestre_dto.g.dart';

/// Formato de `assets/mock/turmas.json` (e do futuro `GET` do resumo).
@freezed
abstract class IndicesDto with _$IndicesDto {
  const factory IndicesDto({
    required num cr,
    required int integralizacaoPercentual,
  }) = _IndicesDto;

  factory IndicesDto.fromJson(Map<String, dynamic> json) =>
      _$IndicesDtoFromJson(json);
}

@freezed
abstract class ResumoTurmaDto with _$ResumoTurmaDto {
  const factory ResumoTurmaDto({
    required int frequenciaPercentual,
    num? ultimaNota,
    String? proximaProva,
  }) = _ResumoTurmaDto;

  factory ResumoTurmaDto.fromJson(Map<String, dynamic> json) =>
      _$ResumoTurmaDtoFromJson(json);
}

@freezed
abstract class TurmaDto with _$TurmaDto {
  const factory TurmaDto({
    required String id,
    required String disciplina,
    required ResumoTurmaDto resumo,
    String? codigo,
    String? horario,
    String? local,
  }) = _TurmaDto;

  factory TurmaDto.fromJson(Map<String, dynamic> json) =>
      _$TurmaDtoFromJson(json);
}

@freezed
abstract class AvaliacaoAgendadaDto with _$AvaliacaoAgendadaDto {
  const factory AvaliacaoAgendadaDto({
    required String turmaId,
    required String titulo,
    required String data,
    String? hora,
  }) = _AvaliacaoAgendadaDto;

  factory AvaliacaoAgendadaDto.fromJson(Map<String, dynamic> json) =>
      _$AvaliacaoAgendadaDtoFromJson(json);
}

@freezed
abstract class ResumoSemestreDto with _$ResumoSemestreDto {
  const factory ResumoSemestreDto({
    required String semestre,
    required IndicesDto indices,
    required List<TurmaDto> turmas,
    required List<AvaliacaoAgendadaDto> proximasAvaliacoes,
  }) = _ResumoSemestreDto;

  factory ResumoSemestreDto.fromJson(Map<String, dynamic> json) =>
      _$ResumoSemestreDtoFromJson(json);
}
