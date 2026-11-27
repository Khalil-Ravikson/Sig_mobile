import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/app.dart';
import 'package:siguema_mobile/core/config/app_config.dart';
import 'package:siguema_mobile/core/config/app_config_provider.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/features/auth/domain/auth_repository.dart';
import 'package:siguema_mobile/features/auth/domain/resultado_login.dart';
import 'package:siguema_mobile/features/auth/domain/vinculo.dart';
import 'package:siguema_mobile/features/auth/presentation/auth_providers.dart';
import 'package:siguema_mobile/features/auth/presentation/vinculo_page.dart';
import 'package:siguema_mobile/features/home/presentation/home_page.dart';

class _RepositorioFalso implements AuthRepository {
  const _RepositorioFalso(this.resultado);

  final ResultadoLogin resultado;

  @override
  Future<Result<ResultadoLogin>> login({
    required String cpf,
    required String senha,
  }) async => Sucesso(resultado);
}

Future<void> _entrarComCpfFicticio(
  WidgetTester tester,
  List<Vinculo> vinculos,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(AppConfig.dev()),
        authRepositoryProvider.overrideWithValue(
          _RepositorioFalso(
            ResultadoLogin(
              nome: 'Maria Teste',
              vinculos: vinculos,
              tokenTemporario: 'tmp',
            ),
          ),
        ),
      ],
      child: const App(),
    ),
  );
  await tester.enterText(find.byType(TextField).at(0), '00000000001');
  await tester.enterText(find.byType(TextField).at(1), 'x');
  await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
  await tester.pumpAndSettle();
}

const _graduacao = Vinculo(
  id: 1,
  tipo: TipoVinculo.aluno,
  descricao: 'Graduação',
);
const _pos = Vinculo(
  id: 2,
  tipo: TipoVinculo.aluno,
  descricao: 'Pós-graduação',
);

void main() {
  testWidgets('abre na tela de login', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(AppConfig.dev())],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('SIGUEMA'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
  });

  testWidgets('com um vínculo pula a escolha e vai para a home', (
    tester,
  ) async {
    await _entrarComCpfFicticio(tester, const [_graduacao]);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(VinculoPage), findsNothing);
    expect(find.text('Graduação'), findsOneWidget);
    expect(find.text('Trocar vínculo'), findsNothing);
  });

  testWidgets('com dois vínculos mostra a escolha e segue com o escolhido', (
    tester,
  ) async {
    await _entrarComCpfFicticio(tester, const [_graduacao, _pos]);
    expect(find.byType(VinculoPage), findsOneWidget);
    await tester.tap(find.text('Pós-graduação'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Pós-graduação'), findsOneWidget);
  });

  testWidgets('Trocar vínculo volta para a escolha', (tester) async {
    await _entrarComCpfFicticio(tester, const [_graduacao, _pos]);
    await tester.tap(find.text('Graduação'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trocar vínculo'));
    await tester.pumpAndSettle();
    expect(find.byType(VinculoPage), findsOneWidget);
  });

  testWidgets('Sair volta para o login', (tester) async {
    await _entrarComCpfFicticio(tester, const [_graduacao]);
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  test('cada ambiente tem sua URL base sem segredos', () {
    expect(AppConfig.dev().apiBaseUrl, startsWith('http://10.0.2.2'));
    expect(AppConfig.homologacao().ambiente, Ambiente.homologacao);
    expect(AppConfig.producao().apiBaseUrl, startsWith('https://'));
  });
}
