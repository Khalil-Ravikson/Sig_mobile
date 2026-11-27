import 'package:freezed_annotation/freezed_annotation.dart';

part 'aula_dia.freezed.dart';

/// Um dia de aula: quantas aulas teve e de quantas o aluno faltou.
@freezed
abstract class AulaDia with _$AulaDia {
  const AulaDia._();

  const factory AulaDia({
    required DateTime data,
    required int aulas,
    @Default(0) int faltas,
  }) = _AulaDia;

  bool get teveFalta => faltas > 0;
}
