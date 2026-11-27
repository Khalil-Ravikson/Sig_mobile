import '../../../core/error/result.dart';
import 'resumo_semestre.dart';

abstract interface class SemestreRepository {
  /// Resumo do semestre atual: índices, turmas e próximas avaliações.
  Future<Result<ResumoSemestre>> carregarResumo();
}
