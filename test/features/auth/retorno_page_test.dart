import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/auth/domain/biometria.dart';
import 'package:siguema_mobile/features/auth/domain/perfil_local.dart';
import 'package:siguema_mobile/features/auth/presentation/auth_providers.dart';
import 'package:siguema_mobile/features/auth/presentation/convite_biometria_sheet.dart';
import 'package:siguema_mobile/features/auth/presentation/retorno_page.dart';

import '../../support/fakes_biometria.dart';

const _perfil = PerfilLocal(cpfMascarado: '***.456.789-**', iniciais: 'AL');

class _Cliques {
  int ok = 0;
  int senha = 0;
  int outroCpf = 0;
}

Future<_Cliques> _abrir(WidgetTester tester, FakeBiometria bio) async {
  final cliques = _Cliques();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [biometriaProvider.overrideWithValue(bio)],
      child: MaterialApp(
        theme: AppTheme.claro(),
        home: RetornoPage(
          perfil: _perfil,
          onBiometriaOk: () => cliques.ok++,
          onUsarSenha: () => cliques.senha++,
          onOutroCpf: () => cliques.outroCpf++,
        ),
      ),
    ),
  );
  return cliques;
}

void main() {
  testWidgets('mostra saudação, iniciais, CPF mascarado e as três saídas', (
    tester,
  ) async {
    await _abrir(tester, FakeBiometria());

    expect(find.text('Olá de novo'), findsOneWidget);
    expect(find.text('AL'), findsOneWidget);
    expect(find.text('CPF ***.456.789-**'), findsOneWidget);
    expect(find.text('Entrar com a digital'), findsOneWidget);
    expect(find.text('Entrar com senha'), findsOneWidget);
    expect(find.text('Usar outro CPF'), findsOneWidget);
    expect(find.text('A digital só vale neste aparelho.'), findsOneWidget);
  });

  testWidgets('digital reconhecida avisa a tela', (tester) async {
    final cliques = await _abrir(tester, FakeBiometria());
    await tester.tap(find.text('Entrar com a digital'));
    await tester.pumpAndSettle();

    expect(cliques.ok, 1);
  });

  testWidgets('digital não reconhecida mostra o erro e deixa tentar de novo', (
    tester,
  ) async {
    final bio = FakeBiometria(
      resultados: [
        ResultadoBiometria.naoReconhecida,
        ResultadoBiometria.sucesso,
      ],
    );
    final cliques = await _abrir(tester, bio);
    await tester.tap(find.text('Entrar com a digital'));
    await tester.pumpAndSettle();

    expect(find.text('Não reconhecemos a digital'), findsOneWidget);
    expect(find.text('Tente de novo ou use a senha.'), findsOneWidget);
    expect(cliques.ok, 0);

    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();
    expect(cliques.ok, 1);
  });

  testWidgets('cancelar a janela do sistema não mostra erro', (tester) async {
    final cliques = await _abrir(
      tester,
      FakeBiometria(resultados: [ResultadoBiometria.cancelada]),
    );
    await tester.tap(find.text('Entrar com a digital'));
    await tester.pumpAndSettle();

    expect(find.text('Olá de novo'), findsOneWidget);
    expect(find.text('Não reconhecemos a digital'), findsNothing);
    expect(cliques.ok, 0);
  });

  testWidgets('digital bloqueada esconde o botão e deixa só a senha', (
    tester,
  ) async {
    await _abrir(
      tester,
      FakeBiometria(resultados: [ResultadoBiometria.bloqueada]),
    );
    await tester.tap(find.text('Entrar com a digital'));
    await tester.pumpAndSettle();

    expect(find.text('Digital bloqueada'), findsOneWidget);
    expect(find.text('Entrar com a digital'), findsNothing);
    expect(find.text('Tentar de novo'), findsNothing);
    expect(find.text('Entrar com senha'), findsOneWidget);
  });

  testWidgets('digital indisponível explica e deixa só a senha', (
    tester,
  ) async {
    await _abrir(
      tester,
      FakeBiometria(resultados: [ResultadoBiometria.indisponivel]),
    );
    await tester.tap(find.text('Entrar com a digital'));
    await tester.pumpAndSettle();

    expect(find.text('Digital indisponível'), findsOneWidget);
    expect(find.text('Entrar com a digital'), findsNothing);
  });

  testWidgets('Entrar com senha e Usar outro CPF chamam os retornos', (
    tester,
  ) async {
    final cliques = await _abrir(tester, FakeBiometria());
    await tester.tap(find.text('Entrar com senha'));
    await tester.tap(find.text('Usar outro CPF'));
    await tester.pump();

    expect(cliques.senha, 1);
    expect(cliques.outroCpf, 1);
    expect(cliques.ok, 0);
  });

  group('convite', () {
    Future<bool?> abrirConvite(WidgetTester tester, String toque) async {
      bool? resposta;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.claro(),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async =>
                    resposta = await mostrarConviteBiometria(context),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      expect(find.text('Entrar com a digital da próxima vez?'), findsOneWidget);
      expect(
        find.text(
          'Sua senha não fica guardada no aparelho. '
          'Você pode desligar depois.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text(toque));
      await tester.pumpAndSettle();
      return resposta;
    }

    testWidgets('Ativar a digital devolve true', (tester) async {
      expect(await abrirConvite(tester, 'Ativar a digital'), isTrue);
    });

    testWidgets('Agora não devolve false', (tester) async {
      expect(await abrirConvite(tester, 'Agora não'), isFalse);
    });
  });
}
