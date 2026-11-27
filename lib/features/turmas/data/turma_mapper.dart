import '../../../core/util/formato_data.dart';
import '../domain/aula_dia.dart';
import '../domain/avaliacao.dart';
import '../domain/docente.dart';
import '../domain/frequencia_resumo.dart';
import '../domain/notas.dart';
import '../domain/turma_detalhe.dart';
import 'frequencia_dto.dart';
import 'turma_detalhe_dto.dart';

/// Isola o formato do JSON (ou da API) do modelo do app.
class TurmaMapper {
  const TurmaMapper._();

  static TurmaDetalhe detalhe(TurmaDetalheDto dto) => TurmaDetalhe(
    id: dto.id,
    turma: dto.turma,
    notas: Notas(
      n1: dto.notas.n1?.toDouble(),
      n2: dto.notas.n2?.toDouble(),
      n3: dto.notas.n3?.toDouble(),
      media: dto.notas.media?.toDouble(),
      segundaChamada: dto.notas.segundaChamada?.toDouble(),
      provaFinal: dto.notas.provaFinal?.toDouble(),
    ),
    avaliacoes: [for (final a in dto.avaliacoes) ?_avaliacao(a)]
      ..sort((a, b) => a.data.compareTo(b.data)),
    docente: Docente(nome: dto.docente.nome, email: dto.docente.email),
  );

  static Avaliacao? _avaliacao(AvaliacaoDto dto) {
    final data = FormatoData.lerData(dto.data);
    if (data == null) return null;
    return Avaliacao(data: data, descricao: dto.descricao, hora: dto.hora);
  }

  /// Dias de aula, **mais recentes primeiro**. Datas inválidas saem.
  static List<AulaDia> dias(FrequenciaDto dto) {
    final dias = <AulaDia>[];
    for (final a in dto.aulas) {
      final data = FormatoData.lerData(a.data);
      if (data == null || a.aulas <= 0) continue;
      dias.add(
        AulaDia(data: data, aulas: a.aulas, faltas: a.faltas.clamp(0, a.aulas)),
      );
    }
    dias.sort((a, b) => b.data.compareTo(a.data));
    return dias;
  }

  static FrequenciaResumo resumo(FrequenciaDto dto) {
    final dias = TurmaMapper.dias(dto);
    final pontos = <bool>[];
    var faltas = 0;
    // Dos mais antigos para os mais novos; dentro do dia, presenças antes.
    for (final dia in dias.reversed) {
      for (var i = 0; i < dia.aulas; i++) {
        final faltou = i >= dia.aulas - dia.faltas;
        pontos.add(faltou);
        if (faltou) faltas++;
      }
    }
    return FrequenciaResumo(
      minimoPercentual: dto.minimoPercentual,
      totalAulas: pontos.length,
      totalFaltas: faltas,
      pontos: pontos,
    );
  }
}
