import 'package:freezed_annotation/freezed_annotation.dart';

part 'avaliacao.freezed.dart';

/// Avaliação de uma turma (a de qualquer turma está em `AvaliacaoAgendada`).
@freezed
abstract class Avaliacao with _$Avaliacao {
  const factory Avaliacao({
    required DateTime data,
    required String descricao,
    String? hora,
  }) = _Avaliacao;
}
