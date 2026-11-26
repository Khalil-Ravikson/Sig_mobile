import 'package:freezed_annotation/freezed_annotation.dart';

part 'avaliacao_agendada.freezed.dart';

/// Prova ou atividade marcada, de qualquer turma do semestre.
@freezed
abstract class AvaliacaoAgendada with _$AvaliacaoAgendada {
  const factory AvaliacaoAgendada({
    required String turmaId,
    required String titulo,
    required DateTime data,
    String? hora,
  }) = _AvaliacaoAgendada;
}
