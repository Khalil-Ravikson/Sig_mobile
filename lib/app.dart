import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'core/config/app_config.dart';
import 'core/config/app_config_provider.dart';
import 'core/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    return MaterialApp.router(
      title: config.nomeApp,
      debugShowCheckedModeBanner: config.ambiente != Ambiente.producao,
      theme: AppTheme.claro(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
