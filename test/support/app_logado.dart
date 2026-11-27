import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/app.dart';
import 'package:siguema_mobile/core/config/app_config.dart';
import 'package:siguema_mobile/core/config/app_config_provider.dart';
import 'package:siguema_mobile/core/config/sem_novas_tentativas.dart';
import 'package:siguema_mobile/core/widgets/avatar_perfil.dart';

import 'app_alpha_de_teste.dart';

/// Abre o app inteiro (JSON de verdade, sem espera) e entra com um usuário
/// de demonstração. Por padrão, o de um vínculo só (cai direto no Início).
Future<void> abrirAppLogado(
  WidgetTester tester, {
  String cpf = '00000000001',
  String senha = 'alpha123',
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: semNovasTentativas,
      overrides: [
        appConfigProvider.overrideWithValue(AppConfig.alpha()),
        ...overridesDoAlpha(),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), cpf);
  await tester.enterText(find.byType(TextField).at(1), senha);
  await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
  await tester.pumpAndSettle();
}

/// Abre o Perfil pela foto do topo.
Future<void> abrirPerfil(WidgetTester tester) async {
  await tester.tap(find.byType(AvatarPerfil));
  await tester.pumpAndSettle();
}
