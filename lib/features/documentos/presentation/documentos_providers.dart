import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/documentos_repository.dart';

/// Sem API ainda: quem usa o app precisa trocar por uma implementação
/// (o alpha faz isso em `main_alpha.dart`).
final documentosRepositoryProvider = Provider<DocumentosRepository>(
  (ref) => throw UnimplementedError(
    'Sem implementação de DocumentosRepository: use main_alpha.dart.',
  ),
);
