import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:siguema_mobile/features/turmas/presentation/widgets/pontos_frequencia.dart';

import '../../support/app_alpha_de_teste.dart';

String _local(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.toString();

Finder _chip(String rotulo) => find.descendant(
  of: find.byType(SingleChildScrollView).first,
  matching: find.text(rotulo),
);

void main() {
  group('Resumo', () {
    testWidgets('mostra frequência, notas, próxima avaliação e docente', (
      tester,
    ) async {
      await abrirTurma(tester, '/turmas/t01');

      // Cabeçalho
      expect(find.text('Turmas'), findsOneWidget);
      expect(find.text('Análise e Processamento de Sinais'), findsOneWidget);
      expect(
        find.text('Turma 01 · Seg e qua · 3º e 4º horário'),
        findsOneWidget,
      );
      // Frequência
      expect(find.text('94%'), findsOneWidget);
      expect(find.text('2 faltas em 32 aulas'), findsOneWidget);
      expect(find.text('Dentro do limite'), findsOneWidget);
      expect(find.text('Ver mapa de frequência'), findsOneWidget);
      // Notas
      expect(find.text('N1'), findsOneWidget);
      expect(find.text('5,0'), findsOneWidget);
      expect(find.text('7,5'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      expect(find.text('Média'), findsOneWidget);
      expect(find.text('6,3'), findsOneWidget);
      // Próxima avaliação
      expect(find.text('Próxima avaliação'), findsOneWidget);
      expect(find.text('Avaliação · Análise de Sinais'), findsOneWidget);
      expect(find.text('03/12 · 08h00 · em 8 dias'), findsOneWidget);
      // Docente
      expect(find.text('Helena Exemplo Prado'), findsOneWidget);
      expect(find.text('HP'), findsOneWidget);
    });

    testWidgets('sem aba na URL abre o Resumo; aba inválida também', (
      tester,
    ) async {
      await abrirTurma(tester, '/turmas/t01?aba=nao-existe');
      expect(find.text('Ver mapa de frequência'), findsOneWidget);
    });

    testWidgets('turma sem aulas nem avaliação', (tester) async {
      await abrirTurma(tester, '/turmas/t03');
      expect(find.text('Ainda sem aulas registradas'), findsOneWidget);
      expect(find.text('Dentro do limite'), findsNothing);
      expect(
        find.text('Nenhuma avaliação marcada por enquanto.'),
        findsOneWidget,
      );
    });

    testWidgets('tocar no docente mostra o e-mail fictício', (tester) async {
      await abrirTurma(tester, '/turmas/t01');
      await tester.ensureVisible(find.text('Helena Exemplo Prado'));
      await tester.tap(find.text('Helena Exemplo Prado'));
      await tester.pump();
      expect(
        find.textContaining('helena.exemplo@exemplo.invalid'),
        findsOneWidget,
      );
    });
  });

  group('chips e URL', () {
    testWidgets('mostra os 5 chips', (tester) async {
      await abrirTurma(tester, '/turmas/t01');
      for (final rotulo in [
        'Resumo',
        'Frequência',
        'Notas',
        'Materiais',
        'Atividades',
      ]) {
        expect(_chip(rotulo), findsOneWidget, reason: rotulo);
      }
    });

    testWidgets('tocar num chip muda a aba e a URL', (tester) async {
      final router = await abrirTurma(tester, '/turmas/t01');
      expect(_local(router), '/turmas/t01');

      await tester.tap(_chip('Frequência'));
      await tester.pumpAndSettle();
      expect(_local(router), '/turmas/t01?aba=frequencia');
      expect(find.text('Mapa de frequência'), findsOneWidget);
      expect(find.text('Cada ponto é uma aula'), findsOneWidget);

      await tester.tap(_chip('Notas'));
      await tester.pumpAndSettle();
      expect(_local(router), '/turmas/t01?aba=notas');
      expect(find.text('Detalhes'), findsOneWidget);
    });

    testWidgets('abrir direto na URL com ?aba=frequencia', (tester) async {
      await abrirTurma(tester, '/turmas/t01?aba=frequencia');
      expect(find.text('Cada ponto é uma aula'), findsOneWidget);
      expect(find.text('2026.2 · 32 aulas ministradas'), findsOneWidget);
    });

    testWidgets('"Ver mapa de frequência" leva à aba Frequência', (
      tester,
    ) async {
      final router = await abrirTurma(tester, '/turmas/t01');
      await tester.ensureVisible(find.text('Ver mapa de frequência'));
      await tester.tap(find.text('Ver mapa de frequência'));
      await tester.pumpAndSettle();
      expect(_local(router), '/turmas/t01?aba=frequencia');
      expect(find.text('Cada ponto é uma aula'), findsOneWidget);
    });

    testWidgets('voltar numa aba que não é o Resumo volta ao Resumo', (
      tester,
    ) async {
      final router = await abrirTurma(tester, '/turmas/t01?aba=notas');
      // O rótulo de voltar mostra a disciplina.
      await tester.tap(find.text('Análise e Processamento de Sinais'));
      await tester.pumpAndSettle();
      expect(_local(router), '/turmas/t01');
      expect(find.text('Ver mapa de frequência'), findsOneWidget);
    });

    testWidgets('voltar no Resumo volta para a lista', (tester) async {
      await abrirTurma(tester, '/turmas/t01');
      await tester.tap(find.text('Turmas'));
      await tester.pumpAndSettle();
      expect(find.text('Lista'), findsOneWidget);
    });

    testWidgets('Materiais e Atividades mostram "em breve"', (tester) async {
      await abrirTurma(tester, '/turmas/t01?aba=materiais');
      expect(find.text('Materiais chegam em breve'), findsOneWidget);

      await tester.tap(_chip('Atividades'));
      await tester.pumpAndSettle();
      expect(find.text('Atividades chegam em breve'), findsOneWidget);
    });

    testWidgets('o chip ativo fica marcado como selecionado', (tester) async {
      final semantica = tester.ensureSemantics();
      await abrirTurma(tester, '/turmas/t01?aba=notas');
      expect(
        tester.getSemantics(
          find.descendant(
            of: find.byType(SingleChildScrollView).first,
            matching: find.bySemanticsLabel('Notas'),
          ),
        ),
        matchesSemantics(
          label: 'Notas',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          hasTapAction: true,
        ),
      );
      semantica.dispose();
    });
  });

  group('Frequência', () {
    testWidgets('mostra limite, pontos e os meses mais recentes', (
      tester,
    ) async {
      await abrirTurma(tester, '/turmas/t01?aba=frequencia');
      expect(find.text('2 faltas · limite de 8'), findsOneWidget);
      expect(find.text('Dentro do limite'), findsOneWidget);
      expect(find.text('Aprova com 75% ou mais de presença'), findsOneWidget);
      expect(find.byType(PontosFrequencia), findsOneWidget);
      expect(find.text('Presente'), findsWidgets);
      expect(find.text('Falta'), findsOneWidget);
      expect(find.text('Novembro'), findsOneWidget);
      expect(find.text('25/11'), findsOneWidget);
      expect(find.text('Qua'), findsWidgets);
      // A segunda página ainda não foi pedida.
      expect(find.text('Agosto'), findsNothing);
    });

    testWidgets('rolar até o fim carrega a próxima página', (tester) async {
      await abrirTurma(tester, '/turmas/t01?aba=frequencia');
      expect(find.text('Agosto'), findsNothing);

      final lista = find.byType(CustomScrollView);
      for (var i = 0; i < 6; i++) {
        await tester.drag(lista, const Offset(0, -700));
        await tester.pumpAndSettle();
      }
      expect(find.text('Agosto'), findsOneWidget);
      expect(find.text('10/08'), findsOneWidget);
      // Acabou: nada de indicador de carregamento.
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('as faltas aparecem com texto, não só com cor', (tester) async {
      await abrirTurma(tester, '/turmas/t01?aba=frequencia');
      final lista = find.byType(CustomScrollView);
      for (var i = 0; i < 6; i++) {
        await tester.drag(lista, const Offset(0, -700));
        await tester.pumpAndSettle();
      }
      expect(find.text('1 falta'), findsWidgets);
    });

    testWidgets('turma sem aulas mostra o estado vazio', (tester) async {
      await abrirTurma(tester, '/turmas/t03?aba=frequencia');
      expect(find.text('Ainda sem aulas registradas.'), findsOneWidget);
    });
  });

  group('Notas', () {
    testWidgets('lista inclui 2ª chamada e prova final', (tester) async {
      await abrirTurma(tester, '/turmas/t01?aba=notas');
      expect(find.text('Nota 1'), findsOneWidget);
      expect(find.text('2ª chamada'), findsOneWidget);
      expect(find.text('Prova final'), findsOneWidget);
      expect(find.text('5,0'), findsNWidgets(2)); // célula e linha
      expect(find.text('6,3'), findsNWidgets(2));
    });
  });

  group('erros', () {
    testWidgets('turma desconhecida mostra a mensagem e o voltar', (
      tester,
    ) async {
      await abrirTurma(tester, '/turmas/zzz');
      expect(find.text('Não foi possível carregar'), findsOneWidget);
      expect(
        find.text('Não encontramos o que você procurava.'),
        findsOneWidget,
      );
      expect(find.text('Turma virtual'), findsOneWidget);

      await tester.tap(find.text('Turmas'));
      await tester.pumpAndSettle();
      expect(find.text('Lista'), findsOneWidget);
    });
  });

  testWidgets('com "Reduzir animações" tudo aparece direto', (tester) async {
    await abrirTurma(tester, '/turmas/t01', reduzirAnimacoes: true);
    expect(find.text('94%'), findsOneWidget);
    expect(find.text('6,3'), findsOneWidget);
  });
}
