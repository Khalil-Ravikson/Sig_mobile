import 'package:freezed_annotation/freezed_annotation.dart';

part 'frequencia_resumo.freezed.dart';

/// Frequência da turma, calculada sobre **todas** as aulas ministradas
/// (as páginas do mapa são só fatias da lista).
@freezed
abstract class FrequenciaResumo with _$FrequenciaResumo {
  const FrequenciaResumo._();

  const factory FrequenciaResumo({
    required int minimoPercentual,
    required int totalAulas,
    required int totalFaltas,

    /// Um item por aula, da mais antiga à mais nova: `true` = falta.
    required List<bool> pontos,
  }) = _FrequenciaResumo;

  /// Presença em % (100 quando ainda não houve aula).
  int get percentual => totalAulas == 0
      ? 100
      : ((totalAulas - totalFaltas) * 100 / totalAulas).round();

  /// Máximo de faltas que ainda mantém a aprovação por presença.
  int get limiteFaltas => (totalAulas * (100 - minimoPercentual) / 100).floor();

  bool get dentroDoLimite => totalFaltas <= limiteFaltas;
}
