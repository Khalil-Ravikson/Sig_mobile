import '../../../core/util/formato_data.dart';
import '../domain/avaliacao_agendada.dart';
import '../domain/resumo_semestre.dart';
import '../domain/turma_resumo.dart';
import 'resumo_semestre_dto.dart';

/// Isola o formato do JSON (ou da API) do modelo do app.
class SemestreMapper {
  const SemestreMapper._();

  static ResumoSemestre resumo(ResumoSemestreDto dto) => ResumoSemestre(
    semestre: dto.semestre,
    cr: dto.indices.cr.toDouble(),
    integralizacaoPercentual: dto.indices.integralizacaoPercentual,
    turmas: dto.turmas.map(turma).toList(),
    // Datas inválidas saem da lista em vez de derrubar a tela.
    proximasAvaliacoes: [for (final a in dto.proximasAvaliacoes) ?avaliacao(a)],
  );

  static TurmaResumo turma(TurmaDto dto) => TurmaResumo(
    id: dto.id,
    disciplina: dto.disciplina,
    codigo: dto.codigo,
    horario: dto.horario,
    local: dto.local,
    frequenciaPercentual: dto.resumo.frequenciaPercentual,
    ultimaNota: dto.resumo.ultimaNota?.toDouble(),
    proximaProva: FormatoData.lerData(dto.resumo.proximaProva),
  );

  static AvaliacaoAgendada? avaliacao(AvaliacaoAgendadaDto dto) {
    final data = FormatoData.lerData(dto.data);
    if (data == null) return null;
    return AvaliacaoAgendada(
      turmaId: dto.turmaId,
      titulo: dto.titulo,
      data: data,
      hora: dto.hora,
    );
  }
}
