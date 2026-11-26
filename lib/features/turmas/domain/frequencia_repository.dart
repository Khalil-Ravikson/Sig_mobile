import '../../../core/error/result.dart';
import 'frequencia_resumo.dart';
import 'pagina_aulas.dart';

abstract interface class FrequenciaRepository {
  /// Totais e pontos de todas as aulas da turma.
  Future<Result<FrequenciaResumo>> carregarResumo(String turmaId);

  /// Aulas por dia, mais recentes primeiro, [tamanho] por vez.
  /// [pagina] começa em 0.
  Future<Result<PaginaAulas>> carregarAulas(
    String turmaId, {
    int pagina = 0,
    int tamanho = 20,
  });
}
