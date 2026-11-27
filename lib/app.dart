import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'core/config/app_config.dart';
import 'core/config/app_config_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/contraste_app.dart';
import 'features/perfil/presentation/configuracoes_provider.dart';

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
      builder: (context, child) {
        // Preferências do Perfil valem no app todo: "Reduzir animações" e
        // "Tamanho do texto" (multiplica o tamanho do sistema).
        final conf = ref.watch(configuracoesProvider);
        final mq = MediaQuery.of(context);
        return ContrasteApp(
          ativo: conf.altoContraste || mq.highContrast,
          child: MediaQuery(
            data: mq.copyWith(
              disableAnimations: mq.disableAnimations || conf.reduzirAnimacoes,
              textScaler: TextScaler.linear(
                mq.textScaler.scale(1) * conf.tamanhoTexto.fator,
              ),
            ),
            child: child!,
          ),
        );
      },
    );
  }
}
