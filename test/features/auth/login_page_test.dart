import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/auth/domain/auth_repository.dart';
import 'package:siguema_mobile/features/auth/domain/resultado_login.dart';
import 'package:siguema_mobile/features/auth/domain/vinculo.dart';
import 'package:siguema_mobile/features/auth/presentation/auth_providers.dart';
import 'package:siguema_mobile/features/auth/presentation/login_page.dart';

class _RepositorioFalso implements AuthRepository {
  _RepositorioFalso(this.resposta);

  final Result<ResultadoLogin> resposta;
  int chamadas = 0;
  String? ultimoCpf;

  @override
  Future<Result<ResultadoLogin>> login({
    required String cpf,
    required String senha,
  }) async {
    chamadas++;
    ultimoCpf = cpf;
    return resposta;
  }

  @override
  Future<Result<void>> escolherVinculo({
    required int vinculoId,
    required String tokenTemporario,
  }) async => const Sucesso<void>(null);

  @override
  Future<void> sair() async {}
}

const _sucesso = Sucesso(
  ResultadoLogin(
    nome: 'Maria Teste',
    vinculos: [
      Vinculo(id: 1, tipo: TipoVinculo.aluno, descricao: 'Engenharia Civil'),
    ],
    tokenTemporario: 'tmp',
  ),
);

Future<void> _abrir(
  WidgetTester tester,
  _RepositorioFalso repo, {
  ValueChanged<ResultadoLogin>? onEntrou,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        theme: AppTheme.claro(),
        home: LoginPage(onEntrou: onEntrou ?? (_) {}),
      ),
    ),
  );
}

Finder get _campoCpf => find.byType(TextField).at(0);
Finder get _campoSenha => find.byType(TextField).at(1);
Finder get _botaoEntrar => find.widgetWithText(FilledButton, 'Entrar');

void main() {
  testWidgets('aplica a máscara no CPF', (tester) async {
    await _abrir(tester, _RepositorioFalso(_sucesso));
    await tester.enterText(_campoCpf, '12345678901');
    expect(find.text('123.456.789-01'), findsOneWidget);
  });

  testWidgets('CPF incompleto mostra erro e não chama o servidor', (
    tester,
  ) async {
    final repo = _RepositorioFalso(_sucesso);
    await _abrir(tester, repo);
    await tester.enterText(_campoCpf, '123');
    await tester.enterText(_campoSenha, 'abc');
    await tester.tap(_botaoEntrar);
    await tester.pump();

    expect(find.text('CPF inválido. Confira os 11 números.'), findsOneWidget);
    expect(find.text('Precisa de ajuda?'), findsOneWidget);
    expect(repo.chamadas, 0);
  });

  testWidgets('senha vazia mostra erro', (tester) async {
    final repo = _RepositorioFalso(_sucesso);
    await _abrir(tester, repo);
    await tester.enterText(_campoCpf, '00000000001');
    await tester.tap(_botaoEntrar);
    await tester.pump();

    expect(find.text('Informe a senha.'), findsOneWidget);
    expect(repo.chamadas, 0);
  });

  testWidgets('login válido envia só os dígitos e avisa a tela', (
    tester,
  ) async {
    final repo = _RepositorioFalso(_sucesso);
    ResultadoLogin? recebido;
    await _abrir(tester, repo, onEntrou: (r) => recebido = r);
    await tester.enterText(_campoCpf, '00000000001');
    await tester.enterText(_campoSenha, 'abc');
    await tester.tap(_botaoEntrar);
    await tester.pumpAndSettle();

    expect(repo.ultimoCpf, '00000000001');
    expect(recebido?.nome, 'Maria Teste');
  });

  testWidgets('credenciais recusadas mostram a mensagem e a ajuda', (
    tester,
  ) async {
    final repo = _RepositorioFalso(const Falha(NaoAutorizado()));
    await _abrir(tester, repo);
    await tester.enterText(_campoCpf, '00000000001');
    await tester.enterText(_campoSenha, 'errada');
    await tester.tap(_botaoEntrar);
    await tester.pumpAndSettle();

    expect(find.text('CPF ou senha inválidos.'), findsOneWidget);
    expect(find.text('Precisa de ajuda?'), findsOneWidget);
  });

  testWidgets('Mostrar alterna a visibilidade da senha', (tester) async {
    await _abrir(tester, _RepositorioFalso(_sucesso));
    expect(tester.widget<TextField>(_campoSenha).obscureText, isTrue);
    await tester.ensureVisible(find.text('Mostrar'));
    await tester.pump();
    await tester.tap(find.text('Mostrar'));
    await tester.pump();
    expect(tester.widget<TextField>(_campoSenha).obscureText, isFalse);
  });
}
