import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/alpha_overrides.dart';
import 'package:siguema_mobile/app.dart';
import 'package:siguema_mobile/core/config/app_config.dart';
import 'package:siguema_mobile/core/config/app_config_provider.dart';
import 'package:siguema_mobile/core/config/sem_novas_tentativas.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';
import 'package:siguema_mobile/core/mock/mock_providers.dart';
import 'package:siguema_mobile/core/widgets/avatar_perfil.dart';
import 'package:siguema_mobile/features/auth/presentation/vinculo_page.dart';
import 'package:siguema_mobile/features/inicio/presentation/inicio_page.dart';
import 'package:siguema_mobile/features/shell/presentation/widgets/barra_bolha.dart';
import 'package:siguema_mobile/features/turmas/presentation/turmas_page.dart';

import 'support/arquivos_bundle.dart';

/// Fluxo completo do alpha: login falso → vínculo → abas → perfil → sair,
/// lendo os JSON de verdade (sem rede, sem banco).
Widget _app() => ProviderScope(
  retry: semNovasTentativas,
  overrides: <Override>[
    appConfigProvider.overrideWithValue(AppConfig.alpha()),
    ...alphaOverrides(),
    assetBundleProvider.overrideWithValue(ArquivosBundle()),
    latenciaProvider.overrideWithValue(FonteJson.semLatencia),
  ],
  child: const App(),
);

Future<void> _abrir(WidgetTester tester) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_app());
  await tester.pumpAndSettle();
}

Future<void> _entrar(
  WidgetTester tester, {
  String cpf = '00000000001',
  String senha = 'alpha123',
}) async {
  await tester.enterText(find.byType(TextField).at(0), cpf);
  await tester.enterText(find.byType(TextField).at(1), senha);
  await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
  await tester.pumpAndSettle();
}

Finder _naBarra(String rotulo) =>
    find.descendant(of: find.byType(BarraBolha), matching: find.text(rotulo));

void main() {
  testWidgets('abre na tela de login', (tester) async {
    await _abrir(tester);
    expect(find.text('SIGUEMA'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
  });

  testWidgets('senha errada continua no login', (tester) async {
    await _abrir(tester);
    await _entrar(tester, senha: 'errada');
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
    expect(find.byType(InicioPage), findsNothing);
    expect(find.byType(VinculoPage), findsNothing);
  });

  testWidgets('com um vínculo pula a escolha e abre o Início', (tester) async {
    await _abrir(tester);
    await _entrar(tester);

    expect(find.byType(VinculoPage), findsNothing);
    expect(find.byType(InicioPage), findsOneWidget);
    expect(find.text('Olá, Ana'), findsOneWidget);
    expect(find.text('Quarta, 25/11 · 2026.2'), findsOneWidget);
    expect(find.text('87%'), findsOneWidget);
    expect(find.text('7,25'), findsOneWidget);
    expect(find.text('Em 8 dias'), findsOneWidget);
    expect(find.byType(BarraBolha), findsOneWidget);
  });

  testWidgets('com dois vínculos mostra a escolha e segue com o escolhido', (
    tester,
  ) async {
    await _abrir(tester);
    await _entrar(tester, cpf: '00000000002');
    expect(find.byType(VinculoPage), findsOneWidget);

    await tester.tap(find.textContaining('Pós-graduação'));
    await tester.pumpAndSettle();
    expect(find.byType(InicioPage), findsOneWidget);
  });

  testWidgets('docente vê "em breve" em vez das telas do discente', (
    tester,
  ) async {
    await _abrir(tester);
    await _entrar(tester, cpf: '00000000003');
    await tester.tap(find.textContaining('Departamento de Engenharia'));
    await tester.pumpAndSettle();

    expect(find.text('A área deste vínculo chega em breve.'), findsOneWidget);
    expect(find.byType(BarraBolha), findsNothing);
  });

  testWidgets('a barra troca de aba: Início → Turmas → turma e volta', (
    tester,
  ) async {
    await _abrir(tester);
    await _entrar(tester);

    await tester.tap(_naBarra('Turmas'));
    await tester.pumpAndSettle();
    expect(find.byType(TurmasPage), findsOneWidget);
    expect(find.text('3 turmas'), findsOneWidget);
    expect(find.text('Análise e Processamento de Sinais'), findsOneWidget);
    expect(find.text('94%'), findsOneWidget);

    await tester.tap(find.text('Análise e Processamento de Sinais'));
    await tester.pumpAndSettle();
    // A turma abre por cima das abas: sem barra inferior.
    expect(find.text('Turma 01 · Seg e qua · 3º e 4º horário'), findsOneWidget);
    expect(find.text('2 faltas em 32 aulas'), findsOneWidget);
    expect(find.byType(BarraBolha), findsNothing);

    // O voltar do cabeçalho leva de volta para a lista.
    await tester.tap(find.text('Turmas'));
    await tester.pumpAndSettle();
    expect(find.byType(BarraBolha), findsOneWidget);
    expect(find.text('3 turmas'), findsOneWidget);

    await tester.tap(_naBarra('Início'));
    await tester.pumpAndSettle();
    expect(find.text('Resumo do semestre'), findsOneWidget);
  });

  testWidgets('a foto do topo abre o Perfil (Hero) e Sair volta ao login', (
    tester,
  ) async {
    await _abrir(tester);
    await _entrar(tester);

    await tester.tap(find.byType(AvatarPerfil));
    await tester.pumpAndSettle();
    expect(find.text('Matrícula ativa'), findsOneWidget);
    expect(find.byType(BarraBolha), findsNothing);

    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
    expect(find.byType(InicioPage), findsNothing);
  });

  test('cada ambiente tem sua URL base sem segredos', () {
    expect(AppConfig.dev().apiBaseUrl, startsWith('http://10.0.2.2'));
    expect(AppConfig.homologacao().ambiente, Ambiente.homologacao);
    expect(AppConfig.producao().apiBaseUrl, startsWith('https://'));
    // O alpha nunca resolve nenhum endereço.
    expect(AppConfig.alpha().apiBaseUrl, endsWith('.invalid'));
  });
}
