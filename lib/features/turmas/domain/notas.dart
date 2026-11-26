import 'package:freezed_annotation/freezed_annotation.dart';

part 'notas.freezed.dart';

/// Notas da turma. `null` = ainda não lançada.
@freezed
abstract class Notas with _$Notas {
  const factory Notas({
    double? n1,
    double? n2,
    double? n3,
    double? media,
    double? segundaChamada,
    double? provaFinal,
  }) = _Notas;
}
