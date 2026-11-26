import 'package:freezed_annotation/freezed_annotation.dart';

import 'avaliacao_agendada.dart';
import 'turma_resumo.dart';

part 'resumo_semestre.freezed.dart';

/// Tudo o que Início e Turmas precisam, vindo de **um** carregamento (evita
/// uma chamada por turma).
@freezed
abstract class ResumoSemestre with _$ResumoSemestre {
  const factory ResumoSemestre({
    required String semestre,
    required double cr,
    required int integralizacaoPercentual,
    required List<TurmaResumo> turmas,
    required List<AvaliacaoAgendada> proximasAvaliacoes,
  }) = _ResumoSemestre;
}
