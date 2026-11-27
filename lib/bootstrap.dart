import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/config/app_config_provider.dart';
import 'core/config/sem_novas_tentativas.dart';

/// Liga o app. [overrides] troca implementações (o alpha usa para ler JSON).
void bootstrap(AppConfig config, {List<Override> overrides = const []}) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      retry: semNovasTentativas,
      overrides: [appConfigProvider.overrideWithValue(config), ...overrides],
      child: const App(),
    ),
  );
}
