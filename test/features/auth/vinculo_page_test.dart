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
import 'package:siguema_mobile/features/auth/presentation/sessao_provider.dart';
import 'package:siguema_mobile/features/auth/presentation/vinculo_page.dart';

class _Repo implements AuthRepository {
  _Repo([this.escolher = const Sucesso<void>(null)]);

  final Result<void> escolher;
  int chamadas = 0;
  int? ultimoVinculo;
  String? ultimoToken;

  @override
  Future<Result<ResultadoLogin>> login({
    required String cpf,
    required String senha,
  }) => throw UnimplementedError();

  @override
  Future<Result<void>> escolherVinculo({
    required int vinculoId,
    required String tokenTemporario,
  }) async {
    chamadas++;
    ultimoVinculo = vinculoId;
    ultimoToken = tokenTemporario;
    return escolher;
  }

  @override
  Future<void> sair() async {}
}

const _prof = Vinculo(
  id: 1,
  tipo: TipoVinculo.professor,
  descricao: 'Dep. de Engenharia de Computação',
);
const _serv = Vinculo(
  id: 2,
  tipo: TipoVinculo.servidor,
  descricao: 'Coordenação de TI',
);

ResultadoLogin _login(List<Vinculo> v) => ResultadoLogin(
  nome: 'Ana Teste da Silva',
  tokenTemporario: 'tmp-ana',
  vinculos: v,
);

Future<ProviderContainer> _abrir(
  WidgetTester tester,
  ResultadoLogin login,
  _Repo repo, {
  VoidCallback? onSair,
}) async {
  final container = ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  container.read(sessaoProvider.notifier).entrou(login);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.claro(),
        home: VinculoPage(resultado: login, onSair: onSair ?? () {}),
      ),
    ),
  );
  return container;
}

void main() {
  testWidgets('saúda pelo primeiro nome e lista todos os vínculos', (
    tester,
  ) async {
    await _abrir(tester, _login([_prof, _serv]), _Repo());
    expect(find.text('Olá, Ana'), findsOneWidget);
    expect(find.text('Portal do Docente'), findsOneWidget);
    expect(find.text('Portal do Servidor'), findsOneWidget);
  });

  testWidgets('tocar num cartão troca o token e marca o vínculo', (
    tester,
  ) async {
    final repo = _Repo();
    final container = await _abrir(tester, _login([_prof, _serv]), repo);
    await tester.tap(find.text('Portal do Servidor'));
    await tester.pumpAndSettle();
    expect(repo.ultimoVinculo, 2);
    expect(repo.ultimoToken, 'tmp-ana');
    expect(container.read(sessaoProvider).vinculo, _serv);
  });

  testWidgets('com um só vínculo escolhe sozinho', (tester) async {
    final repo = _Repo();
    final container = await _abrir(tester, _login([_prof]), repo);
    // Sem roteador a página não sai de cena e o spinner nunca assenta.
    await tester.pump();
    await tester.pump();
    expect(repo.chamadas, 1);
    expect(container.read(sessaoProvider).vinculo, _prof);
  });

  testWidgets('com um só vínculo mostra Entrando… antes de acabar', (
    tester,
  ) async {
    await _abrir(tester, _login([_prof]), _Repo());
    expect(find.text('Entrando…'), findsOneWidget);
    expect(find.text('Portal do Docente'), findsNothing);
  });

  testWidgets('erro na troca mostra a mensagem, não marca o vínculo e deixa '
      'tentar de novo', (tester) async {
    final repo = _Repo(const Falha(SessaoExpirada()));
    final container = await _abrir(tester, _login([_prof, _serv]), repo);
    await tester.tap(find.text('Portal do Docente'));
    await tester.pumpAndSettle();
    expect(find.text('Sua sessão expirou. Entre de novo.'), findsOneWidget);
    expect(container.read(sessaoProvider).vinculoEscolhido, isFalse);
    expect(find.text('Portal do Docente'), findsOneWidget);
    expect(find.text('Sair'), findsOneWidget);
  });

  testWidgets('sem vínculos mostra orientação e Sair', (tester) async {
    var saiu = false;
    await _abrir(tester, _login([]), _Repo(), onSair: () => saiu = true);
    expect(find.textContaining('Nenhum vínculo ativo'), findsOneWidget);
    expect(find.textContaining('Como você quer entrar'), findsNothing);
    await tester.tap(find.text('Sair'));
    expect(saiu, isTrue);
  });
}
