import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/frequencia_repository.dart';
import '../domain/turma_repository.dart';

/// Sem API ainda: quem usa o app precisa trocar por uma implementação
/// (o alpha faz isso em `main_alpha.dart`).
final turmaRepositoryProvider = Provider<TurmaRepository>(
  (ref) => throw UnimplementedError(
    'Sem implementação de TurmaRepository: use main_alpha.dart.',
  ),
);

final frequenciaRepositoryProvider = Provider<FrequenciaRepository>(
  (ref) => throw UnimplementedError(
    'Sem implementação de FrequenciaRepository: use main_alpha.dart.',
  ),
);
