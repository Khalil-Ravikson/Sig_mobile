import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/app_logado.dart';

Future<void> _abrirAjuda(WidgetTester tester) async {
  await abrirAppLogado(tester);
  await abrirPerfil(tester);
  await tester.tap(find.text('Ajuda'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('mostra perguntas, contatos e o botão de relatar', (
    tester,
  ) async {
    await _abrirAjuda(tester);
    expect(find.text('Perguntas e contatos'), findsOneWidget);
    expect(find.text('Perguntas frequentes'), findsOneWidget);
    for (final p in [
      'Esqueci minha senha',
      'Minha nota não apareceu',
      'Como pego o comprovante?',
      'Não vejo uma turma',
    ]) {
      expect(find.text(p), findsOneWidget, reason: p);
    }
    expect(find.text('Falar com alguém'), findsOneWidget);
    expect(find.text('Problema no app'), findsOneWidget);
    expect(find.text('CTIC · suporte do aplicativo'), findsOneWidget);
    expect(find.text('Questão acadêmica'), findsOneWidget);
    await tester.ensureVisible(find.text('Relatar um problema'));
    expect(find.text('Relatar um problema'), findsOneWidget);
  });

  testWidgets('tocar numa pergunta abre e fecha a resposta', (tester) async {
    await _abrirAjuda(tester);
    expect(find.textContaining('O app nunca guarda a sua senha'), findsNothing);

    await tester.tap(find.text('Esqueci minha senha'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('O app nunca guarda a sua senha'),
      findsOneWidget,
    );

    await tester.tap(find.text('Esqueci minha senha'));
    await tester.pumpAndSettle();
    expect(find.textContaining('O app nunca guarda a sua senha'), findsNothing);
  });

  testWidgets('buscar filtra as perguntas só depois de 300 ms', (tester) async {
    await _abrirAjuda(tester);
    await tester.enterText(find.byType(TextField), 'comprovante');
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Esqueci minha senha'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpAndSettle();
    expect(find.text('Como pego o comprovante?'), findsOneWidget);
    expect(find.text('Esqueci minha senha'), findsNothing);
    // Os contatos continuam à mão.
    expect(find.text('Problema no app'), findsOneWidget);
  });

  testWidgets('a busca olha a resposta e ignora acento', (tester) async {
    await _abrirAjuda(tester);
    await tester.enterText(find.byType(TextField), 'MATRICULA');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    // "matrícula" aparece nas respostas de Não vejo uma turma e do comprovante.
    expect(find.text('Não vejo uma turma'), findsOneWidget);
    expect(find.text('Esqueci minha senha'), findsNothing);
  });

  testWidgets('sem resultado mostra a mensagem com o termo', (tester) async {
    await _abrirAjuda(tester);
    await tester.enterText(find.byType(TextField), 'foguete');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(
      find.text('Nenhuma pergunta encontrada para "foguete".'),
      findsOneWidget,
    );
    expect(find.text('Falar com alguém'), findsOneWidget);
  });

  testWidgets('tocar num contato mostra os dados fictícios', (tester) async {
    await _abrirAjuda(tester);
    await tester.ensureVisible(find.text('Problema no app'));
    await tester.tap(find.text('Problema no app'));
    await tester.pumpAndSettle();
    expect(find.textContaining('suporte.app@exemplo.invalid'), findsOneWidget);
    expect(find.textContaining('Contato fictício'), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('suporte.app@'), findsNothing);
  });

  testWidgets('"Relatar um problema" avisa que não envia no alpha', (
    tester,
  ) async {
    await _abrirAjuda(tester);
    await tester.ensureVisible(find.text('Relatar um problema'));
    await tester.tap(find.text('Relatar um problema'));
    await tester.pump();
    expect(find.textContaining('não é enviado a ninguém'), findsOneWidget);
  });

  testWidgets('voltar leva ao Perfil', (tester) async {
    await _abrirAjuda(tester);
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Matrícula ativa'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });
}
