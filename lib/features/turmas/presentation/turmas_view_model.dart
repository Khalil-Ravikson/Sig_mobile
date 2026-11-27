import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/util/formato_data.dart';
import 'resumo_semestre_provider.dart';

part 'turmas_view_model.g.dart';

/// Turma pronta para exibir: textos já formatados.
class TurmaUi {
  const TurmaUi({
    required this.id,
    required this.disciplina,
    required this.horario,
    required this.frequencia,
    required this.ultimaNota,
    required this.proximaProva,
  });

  final String id;
  final String disciplina;
  final String horario;
  final String frequencia;
  final String ultimaNota;
  final String proximaProva;
}

class TurmasUi {
  const TurmasUi({required this.semestre, required this.turmas});

  final String semestre;
  final List<TurmaUi> turmas;
}

/// Aba Turmas: deriva do resumo do semestre (sem nova leitura).
@riverpod
Future<TurmasUi> turmasViewModel(Ref ref) async {
  final resumo = await ref.watch(resumoSemestreProvider.future);
  return TurmasUi(
    semestre: resumo.semestre,
    turmas: [
      for (final t in resumo.turmas)
        TurmaUi(
          id: t.id,
          disciplina: t.disciplina,
          horario: t.horario ?? 'Sem horário definido',
          frequencia: '${t.frequenciaPercentual}%',
          ultimaNota: FormatoData.nota(t.ultimaNota),
          proximaProva: t.proximaProva == null
              ? '—'
              : FormatoData.diaMes(t.proximaProva!),
        ),
    ],
  );
}
