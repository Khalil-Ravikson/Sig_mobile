import 'package:freezed_annotation/freezed_annotation.dart';

part 'documento.freezed.dart';

enum TipoDocumento { pdf, doc }

enum GrupoDocumento { maisUsados, declaracoes }

enum EstadoDocumento {
  /// PDF na hora.
  disponivel,

  /// Retirada na secretaria.
  sobPedido,
}

@freezed
abstract class Documento with _$Documento {
  const factory Documento({
    required String id,
    required String titulo,
    required String subtitulo,
    required TipoDocumento tipo,
    required GrupoDocumento grupo,
    required EstadoDocumento estado,
  }) = _Documento;
}
