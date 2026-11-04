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

class _RepositorioFalso implements AuthRepository {
  const _RepositorioFalso(this.resultado);

  final ResultadoLogin resultado;

  @override
  Future<Result<ResultadoLogin>> login({
    required String cpf,
    required String senha,
  }) async => Sucesso(resultado);
}

void main() {
  testWidgets('abre na tela de login', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(AppConfig.dev())],
        child: const App(),
      ),
    );
    expect(find.text('SIGUEMA'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
  });

  Future<void> entrarComCpfFicticio(
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

  testWidgets('com um vínculo pula a escolha', (tester) async {
    await entrarComCpfFicticio(tester, const [
      Vinculo(id: 1, tipo: TipoVinculo.aluno, descricao: 'Engenharia Civil'),
    ]);
    expect(find.text('Entrando como Engenharia Civil'), findsOneWidget);
    expect(find.byType(VinculoPage), findsNothing);
  });

  testWidgets('com dois vínculos mostra a escolha e segue com o escolhido', (
    tester,
  ) async {
    await entrarComCpfFicticio(tester, const [
      Vinculo(id: 1, tipo: TipoVinculo.aluno, descricao: 'Graduação'),
      Vinculo(id: 2, tipo: TipoVinculo.aluno, descricao: 'Pós-graduação'),
    ]);
    expect(find.byType(VinculoPage), findsOneWidget);
    await tester.tap(find.text('Pós-graduação'));
    await tester.pumpAndSettle();
    expect(find.text('Entrando como Pós-graduação'), findsOneWidget);
  });

  test('cada ambiente tem sua URL base sem segredos', () {
    expect(AppConfig.dev().apiBaseUrl, startsWith('http://10.0.2.2'));
    expect(AppConfig.homologacao().ambiente, Ambiente.homologacao);
    expect(AppConfig.producao().apiBaseUrl, startsWith('https://'));
  });
}
