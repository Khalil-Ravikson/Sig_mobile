import 'package:freezed_annotation/freezed_annotation.dart';

import 'login_dto.dart';

part 'usuarios_demo_dto.freezed.dart';
part 'usuarios_demo_dto.g.dart';

/// Formato de `assets/mock/usuarios.json` (só no alpha). A senha de
/// demonstração é fictícia e nunca vai para release.
@freezed
abstract class UsuarioDemoDto with _$UsuarioDemoDto {
  const factory UsuarioDemoDto({
    required String cpf,
    required String senhaDemo,
    required String nome,
    required List<VinculoDto> vinculos,
  }) = _UsuarioDemoDto;

  factory UsuarioDemoDto.fromJson(Map<String, dynamic> json) =>
      _$UsuarioDemoDtoFromJson(json);
}

@freezed
abstract class UsuariosDemoDto with _$UsuariosDemoDto {
  const factory UsuariosDemoDto({required List<UsuarioDemoDto> usuarios}) =
      _UsuariosDemoDto;

  factory UsuariosDemoDto.fromJson(Map<String, dynamic> json) =>
      _$UsuariosDemoDtoFromJson(json);
}
