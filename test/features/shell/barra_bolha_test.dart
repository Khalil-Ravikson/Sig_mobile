import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/theme/app_colors.dart';
import 'package:siguema_mobile/core/theme/app_icons.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/shell/presentation/widgets/barra_bolha.dart';

const _itens = [
  ItemBarra(icone: AppIcons.inicio, rotulo: 'Início'),
  ItemBarra(icone: AppIcons.turmas, rotulo: 'Turmas'),
  ItemBarra(icone: AppIcons.documentos, rotulo: 'Documentos'),
];

Future<void> _montar(
  WidgetTester tester, {
  required int indice,
  required ValueChanged<int> aoSelecionar,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.claro(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: BarraBolha(
            indice: indice,
            itens: _itens,
            aoSelecionar: aoSelecionar,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('mostra os 3 rótulos e avisa qual aba foi tocada', (
    tester,
  ) async {
    final tocadas = <int>[];
    await _montar(tester, indice: 0, aoSelecionar: tocadas.add);

    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Turmas'), findsOneWidget);
    expect(find.text('Documentos'), findsOneWidget);

    await tester.tap(find.text('Documentos'));
    await tester.tap(find.text('Turmas'));
    expect(tocadas, [2, 1]);
  });

  testWidgets(
    'a aba ativa fica marcada como selecionada para leitores de tela',
    (tester) async {
      final semantica = tester.ensureSemantics();
      await _montar(tester, indice: 1, aoSelecionar: (_) {});
      expect(
        tester.getSemantics(find.bySemanticsLabel('Turmas')),
        matchesSemantics(
          label: 'Turmas',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          hasTapAction: true,
        ),
      );
      semantica.dispose();
    },
  );

  testWidgets('a bolha desliza até a nova aba', (tester) async {
    var indice = 0;
    late StateSetter definir;
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.claro(),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              definir = setState;
              return Align(
                alignment: Alignment.bottomCenter,
                child: BarraBolha(
                  indice: indice,
                  itens: _itens,
                  aoSelecionar: (_) {},
                ),
              );
            },
          ),
        ),
      ),
    );
    final bolha = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration! as BoxDecoration).color == AppColors.azulAcao,
    );
    final inicio = tester.getCenter(bolha);
    expect(inicio.dx, closeTo(24 + 115 * 0.5, 1));

    definir(() => indice = 2);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final meio = tester.getCenter(bolha);
    // Durante a animação a bolha ainda está entre as duas abas.
    expect(meio.dx, greaterThan(inicio.dx));

    await tester.pumpAndSettle();
    final fim = tester.getCenter(bolha);
    expect(fim.dx, greaterThan(meio.dx));
    // A bolha termina centrada na terceira aba (itens de 115 px, margem 24).
    expect(fim.dx, closeTo(24 + 115 * 2.5, 1));
  });
}
