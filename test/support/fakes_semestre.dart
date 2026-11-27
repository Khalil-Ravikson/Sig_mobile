import 'dart:async';

import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/features/turmas/domain/avaliacao_agendada.dart';
import 'package:siguema_mobile/features/turmas/domain/resumo_semestre.dart';
import 'package:siguema_mobile/features/turmas/domain/semestre_repository.dart';
import 'package:siguema_mobile/features/turmas/domain/turma_resumo.dart';

/// Dia fixo dos testes (quarta, 25/11/2026).
DateTime relogioDeTeste() => DateTime(2026, 11, 25);

ResumoSemestre resumoDeTeste({
  List<TurmaResumo>? turmas,
  List<AvaliacaoAgendada>? avaliacoes,
}) => ResumoSemestre(
  semestre: '2026.2',
  cr: 7.25,
  integralizacaoPercentual: 87,
  turmas:
      turmas ??
      [
        TurmaResumo(
          id: 'a1',
          disciplina: 'Disciplina Fictícia Um',
          horario: 'Seg e qua · 3º e 4º horário',
          frequenciaPercentual: 94,
          ultimaNota: 7.5,
          proximaProva: DateTime(2026, 12, 3),
        ),
        const TurmaResumo(
          id: 'a2',
          disciplina: 'Disciplina Fictícia Dois',
          frequenciaPercentual: 100,
        ),
      ],
  proximasAvaliacoes:
      avaliacoes ??
      [
        AvaliacaoAgendada(
          turmaId: 'a1',
          titulo: 'Avaliação · Um',
          data: DateTime(2026, 12, 3),
        ),
        AvaliacaoAgendada(
          turmaId: 'a1',
          titulo: 'Avaliação · Passada',
          data: DateTime(2026, 11, 20),
        ),
        AvaliacaoAgendada(
          turmaId: 'a1',
          titulo: 'Avaliação · Dois',
          data: DateTime(2026, 12, 10),
        ),
      ],
);

class SemestreRepositoryFalso implements SemestreRepository {
  SemestreRepositoryFalso(this.resposta);

  factory SemestreRepositoryFalso.comDados([ResumoSemestre? resumo]) =>
      SemestreRepositoryFalso(Future.value(Sucesso(resumo ?? resumoDeTeste())));

  factory SemestreRepositoryFalso.comFalha() => SemestreRepositoryFalso(
    Future.value(const Falha<ResumoSemestre>(SemConexao())),
  );

  /// Quem controla o tempo: um [Completer] deixa o teste ver o esqueleto.
  factory SemestreRepositoryFalso.pendente(
    Completer<Result<ResumoSemestre>> completer,
  ) => SemestreRepositoryFalso(completer.future);

  final Future<Result<ResumoSemestre>> resposta;
  int chamadas = 0;

  @override
  Future<Result<ResumoSemestre>> carregarResumo() {
    chamadas++;
    return resposta;
  }
}

/// Atalho para montar avaliações nos testes.
abstract final class AvaliacaoDeTeste {
  static AvaliacaoAgendada em(DateTime data, String titulo) =>
      AvaliacaoAgendada(turmaId: 'a1', titulo: titulo, data: data);
}
