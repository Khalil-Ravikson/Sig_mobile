import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/features/inicio/presentation/inicio_page.dart';
import 'package:siguema_mobile/features/inicio/presentation/widgets/esqueleto_inicio.dart';
import 'package:siguema_mobile/features/turmas/domain/resumo_semestre.dart';

import '../../support/fakes_semestre.dart';
import '../../support/pagina_de_teste.dart';

void main() {
  testWidgets('mostra o esqueleto e depois o conteúdo', (tester) async {
    final completer = Completer<Result<ResumoSemestre>>();
    await abrirPagina(
      tester,
      const InicioPage(),
      repositorio: SemestreRepositoryFalso.pendente(completer),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(EsqueletoInicio), findsOneWidget);
    expect(find.text('Resumo do semestre'), findsNothing);
    // O cabeçalho já aparece, com o nome vindo da sessão.
    expect(find.text('Olá, Ana'), findsOneWidget);
    expect(find.text('AS'), findsOneWidget);

    completer.complete(Sucesso(resumoDeTeste()));
    await tester.pumpAndSettle();

    expect(find.byType(EsqueletoInicio), findsNothing);
    expect(find.text('Quarta, 25/11 · 2026.2'), findsOneWidget);
    expect(find.text('Resumo do semestre'), findsOneWidget);
    expect(find.text('87%'), findsOneWidget);
    expect(find.text('7,25'), findsOneWidget);
    expect(find.text('Provas e atividades'), findsOneWidget);
    expect(find.text('Avaliação · Um'), findsOneWidget);
    expect(find.text('Em 8 dias'), findsOneWidget);
    expect(find.text('Em 15 dias'), findsOneWidget);
    expect(find.text('Avaliação · Passada'), findsNothing);
  });

  testWidgets('o anel e o número contam de 0 até o valor', (tester) async {
    await abrirPagina(
      tester,
      const InicioPage(),
      repositorio: SemestreRepositoryFalso.comDados(),
    );
    // Dados prontos, animação do anel ainda no começo.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('87%'), findsNothing);
    expect(find.textContaining('%'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('87%'), findsOneWidget);
  });

  testWidgets('com "Reduzir animações" o valor aparece direto', (tester) async {
    await abrirPagina(
      tester,
      const InicioPage(),
      repositorio: SemestreRepositoryFalso.comDados(),
      reduzirAnimacoes: true,
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('87%'), findsOneWidget);
    expect(find.text('7,25'), findsOneWidget);
  });

  testWidgets('sem provas marcadas mostra o estado vazio', (tester) async {
    await abrirPagina(
      tester,
      const InicioPage(),
      repositorio: SemestreRepositoryFalso.comDados(
        resumoDeTeste(avaliacoes: []),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma prova ou atividade marcada.'), findsOneWidget);
    expect(find.text('Resumo do semestre'), findsOneWidget);
  });

  testWidgets('erro mostra a mensagem e tenta de novo', (tester) async {
    final repositorio = SemestreRepositoryFalso.comFalha();
    await abrirPagina(tester, const InicioPage(), repositorio: repositorio);
    await tester.pumpAndSettle();

    expect(find.text('Não foi possível carregar'), findsOneWidget);
    expect(find.text(const SemConexao().mensagem), findsOneWidget);
    expect(find.text('Tentar de novo'), findsOneWidget);
    expect(repositorio.chamadas, 1);

    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();
    expect(repositorio.chamadas, 2);
  });
}
