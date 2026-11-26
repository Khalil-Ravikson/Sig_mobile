import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/core/theme/motion.dart';
import 'package:siguema_mobile/core/widgets/cartao_pressionavel.dart';
import 'package:siguema_mobile/core/widgets/entrada_escalonada.dart';

Widget _tela(Widget filho, {bool reduzir = false}) => MaterialApp(
  theme: AppTheme.claro(),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: reduzir),
    child: child!,
  ),
  home: Scaffold(body: Center(child: filho)),
);

double _escala(WidgetTester tester) =>
    tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;

void main() {
  group('CartaoPressionavel', () {
    testWidgets('reduz a 0,97 ao pressionar e volta ao soltar', (tester) async {
      var toques = 0;
      await tester.pumpWidget(
        _tela(
          CartaoPressionavel(onTap: () => toques++, child: const Text('Olá')),
        ),
      );
      expect(_escala(tester), 1);

      final gesto = await tester.startGesture(
        tester.getCenter(find.text('Olá')),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(_escala(tester), Motion.escalaPressionado);

      await gesto.up();
      await tester.pumpAndSettle();
      expect(_escala(tester), 1);
      expect(toques, 1);
    });

    testWidgets('sem onTap não é botão nem reage ao toque', (tester) async {
      await tester.pumpWidget(
        _tela(const CartaoPressionavel(child: Text('Só leitura'))),
      );
      await tester.tap(find.text('Só leitura'));
      await tester.pump();
      expect(_escala(tester), 1);
      expect(find.byType(InkWell), findsNothing);
    });
  });

  group('EntradaEscalonada', () {
    double opacidade(WidgetTester tester) {
      final finder = find.descendant(
        of: find.byType(EntradaEscalonada),
        matching: find.byType(Opacity),
      );
      return finder.evaluate().isEmpty
          ? 1
          : tester.widget<Opacity>(finder).opacity;
    }

    testWidgets('começa invisível e termina inteiro', (tester) async {
      await tester.pumpWidget(
        _tela(const EntradaEscalonada(indice: 3, child: Text('Item'))),
      );
      expect(opacidade(tester), 0);
      await tester.pump(const Duration(milliseconds: 200));
      expect(opacidade(tester), inInclusiveRange(0.01, 0.99));
      await tester.pumpAndSettle();
      expect(opacidade(tester), 1);
      expect(find.text('Item'), findsOneWidget);
    });

    testWidgets('depois do 8º item não anima', (tester) async {
      await tester.pumpWidget(
        _tela(
          const EntradaEscalonada(
            indice: Motion.maxItensEscalonados,
            child: Text('Item'),
          ),
        ),
      );
      expect(opacidade(tester), 1);
    });

    testWidgets('com "Reduzir animações" aparece direto', (tester) async {
      await tester.pumpWidget(
        _tela(
          const EntradaEscalonada(indice: 2, child: Text('Item')),
          reduzir: true,
        ),
      );
      expect(opacidade(tester), 1);
    });
  });
}
