import 'package:freezed_annotation/freezed_annotation.dart';

part 'vinculo.freezed.dart';

enum TipoVinculo { aluno, professor, servidor }

/// Vínculo do usuário com a UEMA (modelo do app, não do legado).
@freezed
abstract class Vinculo with _$Vinculo {
  const factory Vinculo({
    required int id,
    required TipoVinculo tipo,
    required String descricao,
    String? matricula,
  }) = _Vinculo;
}
