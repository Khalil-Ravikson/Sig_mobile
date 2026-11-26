import 'package:freezed_annotation/freezed_annotation.dart';

part 'ajuda_dto.freezed.dart';
part 'ajuda_dto.g.dart';

/// Formato de `assets/mock/ajuda.json`.
@freezed
abstract class PerguntaDto with _$PerguntaDto {
  const factory PerguntaDto({
    required String id,
    required String pergunta,
    required String resposta,
  }) = _PerguntaDto;

  factory PerguntaDto.fromJson(Map<String, dynamic> json) =>
      _$PerguntaDtoFromJson(json);
}

@freezed
abstract class ContatoDto with _$ContatoDto {
  const factory ContatoDto({
    required String id,
    required String tipo,
    required String titulo,
    required String descricao,
    required String email,
    required String telefone,
    required String horario,
  }) = _ContatoDto;

  factory ContatoDto.fromJson(Map<String, dynamic> json) =>
      _$ContatoDtoFromJson(json);
}

@freezed
abstract class AjudaDto with _$AjudaDto {
  const factory AjudaDto({
    required List<PerguntaDto> perguntas,
    required List<ContatoDto> contatos,
  }) = _AjudaDto;

  factory AjudaDto.fromJson(Map<String, dynamic> json) =>
      _$AjudaDtoFromJson(json);
}
