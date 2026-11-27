import 'package:freezed_annotation/freezed_annotation.dart';

part 'turma_detalhe_dto.freezed.dart';
part 'turma_detalhe_dto.g.dart';

/// Formato de `assets/mock/turma_<id>.json`. Os `avisos` do arquivo ficam de
/// fora: o design da turma ainda não os mostra.
@freezed
abstract class NotasDto with _$NotasDto {
  const factory NotasDto({
    num? n1,
    num? n2,
    num? n3,
    num? media,
    num? segundaChamada,
    @JsonKey(name: 'final') num? provaFinal,
  }) = _NotasDto;

  factory NotasDto.fromJson(Map<String, dynamic> json) =>
      _$NotasDtoFromJson(json);
}

@freezed
abstract class DocenteDto with _$DocenteDto {
  const factory DocenteDto({required String nome, required String email}) =
      _DocenteDto;

  factory DocenteDto.fromJson(Map<String, dynamic> json) =>
      _$DocenteDtoFromJson(json);
}

@freezed
abstract class AvaliacaoDto with _$AvaliacaoDto {
  const factory AvaliacaoDto({
    required String data,
    required String descricao,
    String? hora,
  }) = _AvaliacaoDto;

  factory AvaliacaoDto.fromJson(Map<String, dynamic> json) =>
      _$AvaliacaoDtoFromJson(json);
}

@freezed
abstract class TurmaDetalheDto with _$TurmaDetalheDto {
  const factory TurmaDetalheDto({
    required String id,
    required String turma,
    required NotasDto notas,
    required List<AvaliacaoDto> avaliacoes,
    required DocenteDto docente,
  }) = _TurmaDetalheDto;

  factory TurmaDetalheDto.fromJson(Map<String, dynamic> json) =>
      _$TurmaDetalheDtoFromJson(json);
}
