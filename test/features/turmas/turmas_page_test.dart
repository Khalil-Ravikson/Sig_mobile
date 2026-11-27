import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/features/turmas/domain/resumo_semestre.dart';
import 'package:siguema_mobile/features/turmas/presentation/turmas_page.dart';
import 'package:siguema_mobile/features/turmas/presentation/widgets/esqueleto_turmas.dart';

import '../../support/fakes_semestre.dart';
import '../../support/pagina_de_teste.dart';

void main() {
  testWidgets('esqueleto primeiro, depois os cartões do semestre', (
    tester,
  ) async {
    final completer = Completer<Result<ResumoSemestre>>();
    await abrirPagina(
      tester,
      const TurmasPage(),
      repositorio: SemestreRepositoryFalso.pendente(completer),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(EsqueletoTurmas), findsOneWidget);
    expect(find.text('Turmas'), findsOneWidget);

    completer.complete(Sucesso(resumoDeTeste()));
    await tester.pumpAndSettle();

    expect(find.byType(EsqueletoTurmas), findsNothing);
    expect(find.text('Semestre 2026.2'), findsOneWidget);
    expect(find.text('2 turmas'), findsOneWidget);
    expect(find.text('Disciplina Fictícia Um'), findsOneWidget);
    expect(find.text('Seg e qua · 3º e 4º horário'), findsOneWidget);
    expect(find.text('94%'), findsOneWidget);
    expect(find.text('7,5'), findsOneWidget);
    expect(find.text('03/12'), findsOneWidget);
    expect(find.text('Disciplina Fictícia Dois'), findsOneWidget);
    expect(find.text('Sem horário definido'), findsOneWidget);
    expect(find.text('Frequência'), findsNWidgets(2));
    expect(find.text('—'), findsNWidgets(2));
  });

  testWidgets('semestre sem turmas mostra o estado vazio', (tester) async {
    await abrirPagina(
      tester,
      const TurmasPage(),
      repositorio: SemestreRepositoryFalso.comDados(
        resumoDeTeste(turmas: [], avaliacoes: []),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma turma neste semestre.'), findsOneWidget);
  });

  testWidgets('falha mostra o erro e permite tentar de novo', (tester) async {
    final repositorio = SemestreRepositoryFalso.comFalha();
    await abrirPagina(tester, const TurmasPage(), repositorio: repositorio);
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar'), findsOneWidget);

    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();
    expect(repositorio.chamadas, 2);
  });
}
