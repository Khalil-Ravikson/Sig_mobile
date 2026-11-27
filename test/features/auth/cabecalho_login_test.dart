import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/auth/presentation/login_page.dart';
import 'package:siguema_mobile/features/auth/presentation/widgets/cabecalho_login.dart';

const _subtitulo =
    'Sistema Integrado de Gestão de Atividades Acadêmicas · UEMA';

Widget _app(Widget filho) => MaterialApp(
  theme: AppTheme.claro(),
  home: Scaffold(body: filho),
);

void main() {
  testWidgets('cabeçalho cheio mostra brasão, nome e descrição', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const CabecalhoLogin()));

    expect(find.bySemanticsLabel('Brasão da UEMA'), findsOneWidget);
    expect(find.text('SIGUEMA'), findsOneWidget);
    expect(find.text(_subtitulo), findsOneWidget);
    expect(
      tester.getSize(find.byType(CabecalhoLogin)).height,
      CabecalhoLogin.alturaCheia,
    );
  });

  testWidgets('cabeçalho compacto some com a descrição e fica mais baixo', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const CabecalhoLogin(compacto: true)));

    expect(find.text('SIGUEMA'), findsOneWidget);
    expect(find.text(_subtitulo), findsNothing);
    expect(
      tester.getSize(find.byType(CabecalhoLogin)).height,
      CabecalhoLogin.alturaCompacta,
    );
  });

  testWidgets('com o teclado aberto o login usa o cabeçalho compacto', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.claro(),
          home: LoginPage(onEntrou: (_) {}),
        ),
      ),
    );
    expect(find.text(_subtitulo), findsOneWidget);

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pump();

    expect(find.text(_subtitulo), findsNothing);
    expect(find.text('Entrar'), findsWidgets);
  });
}
