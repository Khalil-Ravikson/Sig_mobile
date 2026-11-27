import 'package:freezed_annotation/freezed_annotation.dart';

part 'aluno_dto.freezed.dart';
part 'aluno_dto.g.dart';

/// Formato de `assets/mock/aluno.json`.
@freezed
abstract class IntegralizacaoDto with _$IntegralizacaoDto {
  const factory IntegralizacaoDto({
    required int percentual,
    required int horasObrigatoriasFaltam,
    required int horasOptativasFaltam,
  }) = _IntegralizacaoDto;

  factory IntegralizacaoDto.fromJson(Map<String, dynamic> json) =>
      _$IntegralizacaoDtoFromJson(json);
}

@freezed
abstract class AlunoDto with _$AlunoDto {
  const factory AlunoDto({
    required String nome,
    required String iniciais,
    required String matricula,
    required String curso,
    required String nivel,
    required String status,
    required String entrada,
    required int periodo,
    required num cr,
    required IntegralizacaoDto integralizacao,
    required String email,
    required String telefone,
  }) = _AlunoDto;

  factory AlunoDto.fromJson(Map<String, dynamic> json) =>
      _$AlunoDtoFromJson(json);
}
