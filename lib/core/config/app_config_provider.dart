import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

/// Config do ambiente atual. Sobrescrita no `ProviderScope` de cada `main_*`.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider não foi sobrescrito'),
);
