import 'package:freezed_annotation/freezed_annotation.dart';

part 'documentos_dto.freezed.dart';
part 'documentos_dto.g.dart';

/// Formato de `assets/mock/documentos.json`.
@freezed
abstract class DocumentoDto with _$DocumentoDto {
  const factory DocumentoDto({
    required String id,
    required String titulo,
    required String subtitulo,
    required String tipo,
    required String grupo,
    required String estado,
  }) = _DocumentoDto;

  factory DocumentoDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentoDtoFromJson(json);
}

@freezed
abstract class DocumentosDto with _$DocumentosDto {
  const factory DocumentosDto({required List<DocumentoDto> itens}) =
      _DocumentosDto;

  factory DocumentosDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentosDtoFromJson(json);
}
