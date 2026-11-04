import 'package:freezed_annotation/freezed_annotation.dart';

part 'vinculo_dto.freezed.dart';
part 'vinculo_dto.g.dart';

/// Resposta de `POST /auth/vinculo` (contrato proposto).
@freezed
abstract class EscolhaVinculoResponseDto with _$EscolhaVinculoResponseDto {
  const factory EscolhaVinculoResponseDto({
    required String token,
    required int expiraEm,
  }) = _EscolhaVinculoResponseDto;

  factory EscolhaVinculoResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EscolhaVinculoResponseDtoFromJson(json);
}
