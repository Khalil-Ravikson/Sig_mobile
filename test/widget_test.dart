import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/app.dart';
import 'package:siguema_mobile/core/config/app_config.dart';
import 'package:siguema_mobile/core/config/app_config_provider.dart';

void main() {
  testWidgets('abre a tela inicial vazia', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(AppConfig.dev())],
        child: const App(),
      ),
    );
    expect(find.text('SIGUEMA'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  test('cada ambiente tem sua URL base sem segredos', () {
    expect(AppConfig.dev().apiBaseUrl, startsWith('http://10.0.2.2'));
    expect(AppConfig.homologacao().ambiente, Ambiente.homologacao);
    expect(AppConfig.producao().apiBaseUrl, startsWith('https://'));
  });
}
