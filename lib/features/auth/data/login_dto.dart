import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

/// Formato da rede (contrato proposto). Pode mudar quando a API real chegar.
@freezed
abstract class VinculoDto with _$VinculoDto {
  const factory VinculoDto({
    required int id,
    required String tipo,
    required String descricao,
    String? matricula,
  }) = _VinculoDto;

  factory VinculoDto.fromJson(Map<String, dynamic> json) =>
      _$VinculoDtoFromJson(json);
}

@freezed
abstract class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    required String nome,
    required List<VinculoDto> vinculos,
    required String tokenTemporario,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}
