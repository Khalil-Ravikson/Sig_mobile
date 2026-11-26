import 'package:freezed_annotation/freezed_annotation.dart';

part 'turma_resumo.freezed.dart';

/// Turma do semestre como o app a mostra nas listas (Início e Turmas).
@freezed
abstract class TurmaResumo with _$TurmaResumo {
  const factory TurmaResumo({
    required String id,
    required String disciplina,
    required int frequenciaPercentual,
    String? codigo,
    String? horario,
    String? local,
    double? ultimaNota,
    DateTime? proximaProva,
  }) = _TurmaResumo;
}
