import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/features/auth/presentation/vinculo_page.dart';
import 'package:siguema_mobile/features/documentos/presentation/documentos_page.dart';
import 'package:siguema_mobile/features/inicio/presentation/inicio_page.dart';
import 'package:siguema_mobile/features/shell/presentation/widgets/barra_bolha.dart';

import '../../support/app_logado.dart';

void main() {
  group('Perfil', () {
    testWidgets('mostra identidade, resumo do curso e os 4 atalhos', (
      tester,
    ) async {
      await abrirAppLogado(tester);
      await abrirPerfil(tester);

      expect(find.text('Ana Exemplo Souza'), findsOneWidget);
      expect(find.text('AS'), findsOneWidget);
      expect(find.text('Discente · Matrícula 2022000001'), findsOneWidget);
      expect(find.text('Matrícula ativa'), findsOneWidget);
      expect(find.text('7,25'), findsOneWidget);
      expect(find.text('CR'), findsOneWidget);
      expect(find.text('7º'), findsOneWidget);
      expect(find.text('Período'), findsOneWidget);
      expect(find.text('87%'), findsOneWidget);
      expect(find.text('Integralizado'), findsOneWidget);
      expect(
        find.text('Faltam 480 h obrigatórias e 0 h optativas.'),
        findsOneWidget,
      );
      for (final titulo in [
        'Meus dados',
        'Meus documentos',
        'Configurações',
        'Ajuda',
      ]) {
        expect(find.text(titulo), findsOneWidget, reason: titulo);
      }
      expect(find.text('Sair'), findsOneWidget);
      expect(find.byType(BarraBolha), findsNothing);
    });

    testWidgets('o botão de voltar leva ao Início', (tester) async {
      await abrirAppLogado(tester);
      await abrirPerfil(tester);
      await tester.tap(find.bySemanticsLabel('Voltar'));
      await tester.pumpAndSettle();
      expect(find.byType(InicioPage), findsOneWidget);
      expect(find.byType(BarraBolha), findsOneWidget);
    });

    testWidgets('"Meus documentos" abre a aba Documentos', (tester) async {
      await abrirAppLogado(tester);
      await abrirPerfil(tester);
      await tester.tap(find.text('Meus documentos'));
      await tester.pumpAndSettle();
      expect(find.byType(DocumentosPage), findsOneWidget);
      expect(find.byType(BarraBolha), findsOneWidget);
    });

    testWidgets('Sair volta ao login', (tester) async {
      await abrirAppLogado(tester);
      await abrirPerfil(tester);
      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(FilledButton, 'Entrar'), findsOneWidget);
    });
  });

  group('Meus dados', () {
    testWidgets('mostra os dados em leitura e o aviso do portal', (
      tester,
    ) async {
      await abrirAppLogado(tester);
      await abrirPerfil(tester);
      await tester.tap(find.text('Meus dados'));
      await tester.pumpAndSettle();

      expect(find.text('Como estão no SIGUEMA'), findsOneWidget);
      for (final texto in [
        '2022000001',
        'Engenharia de Computação',
        'Graduação',
        'Ativo',
        '2022.1',
        'ana.exemplo@exemplo.invalid',
        '(98) 90000-0000',
      ]) {
        expect(find.text(texto), findsOneWidget, reason: texto);
      }
      expect(find.text('Quer corrigir algum dado?'), findsOneWidget);
      expect(find.textContaining('acontece no portal'), findsOneWidget);
      // Só leitura: nenhum campo de texto.
      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.text('Atualizar no portal'));
      await tester.pump();
      expect(
        find.textContaining('portal abriria no navegador'),
        findsOneWidget,
      );
    });

    testWidgets('voltar leva ao Perfil', (tester) async {
      await abrirAppLogado(tester);
      await abrirPerfil(tester);
      await tester.tap(find.text('Meus dados'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();
      expect(find.text('Matrícula ativa'), findsOneWidget);
    });
  });

  group('Configurações', () {
    Future<void> abrirConfig(WidgetTester tester, {String? cpf}) async {
      await abrirAppLogado(tester, cpf: cpf ?? '00000000001');
      if (cpf == '00000000002') {
        await tester.tap(find.textContaining('Engenharia de Computação').first);
        await tester.pumpAndSettle();
      }
      await abrirPerfil(tester);
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();
    }

    testWidgets('mostra as três seções', (tester) async {
      await abrirConfig(tester);
      expect(find.text('Conta e acessibilidade'), findsNothing);
      expect(find.text('Conta'), findsOneWidget);
      expect(find.text('Entrar com a digital'), findsOneWidget);
      expect(find.text('Ligada neste aparelho'), findsOneWidget);
      expect(find.text('Acessibilidade'), findsOneWidget);
      expect(find.text('Tamanho do texto'), findsOneWidget);
      for (final r in ['Pequeno', 'Médio', 'Grande']) {
        expect(find.text(r), findsOneWidget);
      }
      expect(find.text('Alto contraste'), findsOneWidget);
      expect(find.text('Reduzir animações'), findsOneWidget);
      expect(find.text('Privacidade e app'), findsOneWidget);
      expect(find.text('Dados guardados no aparelho'), findsOneWidget);
      expect(find.text('Política de privacidade'), findsOneWidget);
      expect(find.text('Sobre o app'), findsOneWidget);
      expect(find.text('Versão 0.0.1 (alpha)'), findsOneWidget);
    });

    testWidgets('com um só vínculo não oferece "Trocar vínculo"', (
      tester,
    ) async {
      await abrirConfig(tester);
      expect(find.text('Trocar vínculo'), findsNothing);
    });

    testWidgets('com dois vínculos, "Trocar vínculo" volta à escolha', (
      tester,
    ) async {
      await abrirConfig(tester, cpf: '00000000002');
      expect(find.text('Trocar vínculo'), findsOneWidget);
      expect(find.textContaining('Discente · '), findsOneWidget);
      await tester.tap(find.text('Trocar vínculo'));
      await tester.pumpAndSettle();
      expect(find.byType(VinculoPage), findsOneWidget);
    });

    testWidgets('a digital liga e desliga', (tester) async {
      await abrirConfig(tester);
      await tester.tap(find.text('Entrar com a digital'));
      await tester.pumpAndSettle();
      expect(find.text('Desligada'), findsOneWidget);
      await tester.tap(find.text('Entrar com a digital'));
      await tester.pumpAndSettle();
      expect(find.text('Ligada neste aparelho'), findsOneWidget);
    });

    testWidgets('o interruptor avisa o estado para leitores de tela', (
      tester,
    ) async {
      final semantica = tester.ensureSemantics();
      await abrirConfig(tester);
      expect(
        find.bySemanticsLabel('Alto contraste, desligado'),
        findsOneWidget,
      );
      await tester.tap(find.text('Alto contraste'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Alto contraste, ligado'), findsOneWidget);
      semantica.dispose();
    });

    testWidgets('"Reduzir animações" vale no app todo', (tester) async {
      await abrirConfig(tester);
      final contexto = tester.element(find.text('Reduzir animações'));
      expect(MediaQuery.disableAnimationsOf(contexto), isFalse);

      await tester.tap(find.text('Reduzir animações'));
      await tester.pumpAndSettle();
      expect(
        MediaQuery.disableAnimationsOf(tester.element(find.text('Conta'))),
        isTrue,
      );
    });

    testWidgets('"Tamanho do texto" muda a escala do app todo', (tester) async {
      await abrirConfig(tester);
      double escala() =>
          MediaQuery.textScalerOf(tester.element(find.text('Conta'))).scale(10);
      expect(escala(), 10);

      await tester.tap(find.text('Grande'));
      await tester.pumpAndSettle();
      expect(escala(), closeTo(11.5, 0.01));

      await tester.tap(find.text('Pequeno'));
      await tester.pumpAndSettle();
      expect(escala(), closeTo(9, 0.01));

      await tester.tap(find.text('Médio'));
      await tester.pumpAndSettle();
      expect(escala(), 10);
    });

    testWidgets('a escolha continua depois de sair da tela', (tester) async {
      final semantica = tester.ensureSemantics();
      await abrirConfig(tester);
      await tester.tap(find.text('Reduzir animações'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();
      expect(
        find.bySemanticsLabel('Reduzir animações, ligado'),
        findsOneWidget,
      );
      expect(
        MediaQuery.disableAnimationsOf(tester.element(find.text('Conta'))),
        isTrue,
      );
      semantica.dispose();
    });

    testWidgets('"Dados guardados no aparelho" explica o que fica', (
      tester,
    ) async {
      await abrirConfig(tester);
      await tester.ensureVisible(find.text('Dados guardados no aparelho'));
      await tester.tap(find.text('Dados guardados no aparelho'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('A sua senha nunca é guardada'),
        findsOneWidget,
      );
      await tester.tap(find.text('Entendi'));
      await tester.pumpAndSettle();
      expect(find.textContaining('nunca é guardada'), findsNothing);
    });
  });
}
