import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:siguema_mobile/core/theme/app_colors.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/core/theme/contraste_app.dart';
import 'package:siguema_mobile/core/theme/motion.dart';
import 'package:siguema_mobile/core/widgets/anel_progresso.dart';
import 'package:siguema_mobile/core/widgets/avatar_perfil.dart';
import 'package:siguema_mobile/core/widgets/brilho_esqueleto.dart';
import 'package:siguema_mobile/core/widgets/campo_busca.dart';
import 'package:siguema_mobile/core/widgets/cartao_pressionavel.dart';
import 'package:siguema_mobile/core/widgets/escala_ao_pressionar.dart';
import 'package:siguema_mobile/core/widgets/interruptor.dart';
import 'package:siguema_mobile/core/widgets/linha_menu.dart';
import 'package:siguema_mobile/core/widgets/selo_situacao.dart';
import 'package:siguema_mobile/core/widgets/transicao_pagina.dart';
import 'package:siguema_mobile/features/perfil/presentation/configuracoes_page.dart';
import 'package:siguema_mobile/features/shell/presentation/widgets/barra_bolha.dart';

import '../support/app_logado.dart';

/// Monta [filho] com o contraste e o movimento escolhidos.
Widget _tela(
  Widget filho, {
  bool contraste = false,
  bool reduzir = false,
  bool? contrasteDoSistema,
}) => MaterialApp(
  theme: AppTheme.claro(),
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      disableAnimations: reduzir,
      highContrast: contrasteDoSistema ?? false,
    ),
    child: contrasteDoSistema == null
        ? ContrasteApp(ativo: contraste, child: child!)
        : child!,
  ),
  home: Scaffold(body: Center(child: filho)),
);

BoxDecoration _decoracaoDo(WidgetTester tester, Type tipo) {
  final caixa = find
      .descendant(of: find.byType(tipo), matching: find.byType(DecoratedBox))
      .first;
  return tester.widget<DecoratedBox>(caixa).decoration as BoxDecoration;
}

void main() {
  group('alto contraste', () {
    testWidgets('cartão: sombra suave no normal; borda e sem sombra no alto', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tela(const CartaoPressionavel(child: Text('x'))),
      );
      var d = _decoracaoDo(tester, CartaoPressionavel);
      expect(d.border, isNull);
      expect(d.boxShadow, isNotEmpty);

      await tester.pumpWidget(
        _tela(const CartaoPressionavel(child: Text('x')), contraste: true),
      );
      d = _decoracaoDo(tester, CartaoPressionavel);
      expect(d.boxShadow, isEmpty);
      final borda = d.border! as Border;
      expect(borda.top.width, 1.5);
      expect(borda.top.color, AppColors.marinho);
    });

    testWidgets('o ajuste de contraste do sistema também liga o modo', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tela(
          const CartaoPressionavel(child: Text('x')),
          contrasteDoSistema: true,
        ),
      );
      expect(_decoracaoDo(tester, CartaoPressionavel).border, isNotNull);
    });

    testWidgets('lista: fios mais escuros e borda no cartão', (tester) async {
      await tester.pumpWidget(
        _tela(
          const CartaoLista(
            children: [
              LinhaMenu(icone: Icons.home, titulo: 'A'),
              LinhaMenu(icone: Icons.home, titulo: 'B'),
            ],
          ),
          contraste: true,
        ),
      );
      expect(_decoracaoDo(tester, CartaoLista).border, isNotNull);
      expect(
        tester.widget<Divider>(find.byType(Divider)).color,
        AppColors.textoSecundario,
      );
    });

    testWidgets('campo de busca e seletor ganham borda e ficam brancos', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tela(CampoBusca(rotulo: 'Buscar', aoMudar: (_) {}), contraste: true),
      );
      final campo = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final d = campo.decoration! as BoxDecoration;
      expect(d.color, AppColors.branco);
      expect(d.border, isNotNull);
    });

    testWidgets('selo de situação ganha borda na própria cor', (tester) async {
      await tester.pumpWidget(
        _tela(const SeloSituacao.sucesso('Presente'), contraste: true),
      );
      final d = _decoracaoDo(tester, SeloSituacao);
      expect((d.border! as Border).top.color, AppColors.sucesso);
    });

    testWidgets('interruptor desligado fica mais escuro', (tester) async {
      await tester.pumpWidget(
        _tela(const Interruptor(ligado: false), contraste: true),
      );
      final d =
          tester
                  .widget<AnimatedContainer>(find.byType(AnimatedContainer))
                  .decoration!
              as BoxDecoration;
      expect(d.color, AppColors.textoSecundario);
    });

    testWidgets('a barra inferior ganha contorno em vez de sombra', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      const barra = BarraBolha(
        indice: 0,
        itens: [
          ItemBarra(icone: Icons.home, rotulo: 'A'),
          ItemBarra(icone: Icons.book, rotulo: 'B'),
        ],
        aoSelecionar: _nada,
      );
      await tester.pumpWidget(
        _tela(Align(alignment: Alignment.bottomCenter, child: barra)),
      );
      await tester.pumpWidget(
        _tela(
          Align(alignment: Alignment.bottomCenter, child: barra),
          contraste: true,
        ),
      );
      expect(
        tester.renderObject(
          find
              .descendant(
                of: find.byType(BarraBolha),
                matching: find.byType(CustomPaint),
              )
              .first,
        ),
        paints
          ..path(color: AppColors.branco)
          ..path(color: AppColors.marinho, style: PaintingStyle.stroke),
      );
    });

    testWidgets('a trilha do anel aparece sobre o branco', (tester) async {
      await tester.pumpWidget(
        _tela(const AnelProgresso(valor: 0.5), contraste: true),
      );
      await tester.pumpAndSettle();
      expect(
        tester.renderObject(
          find
              .descendant(
                of: find.byType(AnelProgresso),
                matching: find.byType(CustomPaint),
              )
              .first,
        ),
        paints..arc(color: AppColors.textoSuave),
      );
    });

    testWidgets('ligar nas Configurações vale no app todo, e desligar volta', (
      tester,
    ) async {
      await abrirAppLogado(tester);
      await abrirPerfil(tester);
      await tester.tap(find.text('Configurações'));
      await tester.pumpAndSettle();

      final contexto = tester.element(find.byType(ConfiguracoesPage));
      expect(contexto.altoContraste, isFalse);
      expect(contexto.fundoDaTela, AppColors.fundoTela);

      await tester.tap(find.text('Alto contraste'));
      await tester.pumpAndSettle();
      final ligado = tester.element(find.byType(ConfiguracoesPage));
      expect(ligado.altoContraste, isTrue);
      expect(ligado.fundoDaTela, AppColors.branco);
      // O cartão da própria tela já mostra a borda.
      expect(_decoracaoDo(tester, CartaoLista).border, isNotNull);

      await tester.tap(find.text('Alto contraste'));
      await tester.pumpAndSettle();
      expect(
        tester.element(find.byType(ConfiguracoesPage)).altoContraste,
        isFalse,
      );
    });
  });

  group('reduzir animações', () {
    testWidgets('a foto só "voa" (Hero) com o movimento normal', (
      tester,
    ) async {
      await tester.pumpWidget(_tela(const AvatarPerfil(iniciais: 'AS')));
      expect(find.byType(Hero), findsOneWidget);

      await tester.pumpWidget(
        _tela(const AvatarPerfil(iniciais: 'AS'), reduzir: true),
      );
      expect(find.byType(Hero), findsNothing);
      expect(find.text('AS'), findsOneWidget);
    });

    testWidgets('botões reduzem a 0,97 ao toque, e sem animar se reduzido', (
      tester,
    ) async {
      Future<void> montar(bool reduzir) => tester.pumpWidget(
        _tela(
          const EscalaAoPressionar(child: SizedBox(width: 80, height: 40)),
          reduzir: reduzir,
        ),
      );
      double escala() =>
          tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale;
      Duration duracao() =>
          tester.widget<AnimatedScale>(find.byType(AnimatedScale)).duration;

      await montar(false);
      expect(escala(), 1);
      final gesto = await tester.startGesture(
        tester.getCenter(find.byType(EscalaAoPressionar)),
      );
      await tester.pump();
      expect(escala(), Motion.escalaPressionado);
      expect(duracao(), Motion.rapido);
      await gesto.up();
      await tester.pump();
      expect(escala(), 1);

      await montar(true);
      expect(duracao(), Duration.zero);
    });

    testWidgets('campo de busca e interruptor trocam sem animar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _tela(CampoBusca(rotulo: 'x', aoMudar: (_) {}), reduzir: true),
      );
      expect(
        tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer).first)
            .duration,
        Duration.zero,
      );
      await tester.pumpWidget(
        _tela(const Interruptor(ligado: true), reduzir: true),
      );
      expect(
        tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer))
            .duration,
        Duration.zero,
      );
    });

    testWidgets('o brilho do esqueleto fica parado', (tester) async {
      const esqueleto = BrilhoEsqueleto(
        child: CaixaEsqueleto(largura: 100, altura: 20),
      );
      await tester.pumpWidget(_tela(esqueleto));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.transientCallbackCount, greaterThan(0));

      await tester.pumpWidget(_tela(esqueleto, reduzir: true));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.binding.transientCallbackCount, 0);
    });

    testWidgets('a página abre com um fade curto, sem deslocamento', (
      tester,
    ) async {
      Future<GoRouter> abrir(bool reduzir) async {
        final router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(body: Text('base')),
              routes: [
                GoRoute(
                  path: 'p',
                  pageBuilder: (context, state) => paginaSuave<void>(
                    key: state.pageKey,
                    child: const Scaffold(body: Text('pagina')),
                  ),
                ),
              ],
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduzir),
              child: child!,
            ),
          ),
        );
        await tester.pumpAndSettle();
        return router;
      }

      double opacidade() {
        final fades = tester.widgetList<FadeTransition>(
          find.ancestor(
            of: find.text('pagina'),
            matching: find.byType(FadeTransition),
          ),
        );
        return fades
            .map((f) => f.opacity.value)
            .reduce((a, b) => a < b ? a : b);
      }

      final router = await abrir(true);
      router.go('/p');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 170));
      expect(opacidade(), 1);
      await tester.pumpAndSettle();

      final normal = await abrir(false);
      normal.go('/p');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 170));
      expect(opacidade(), lessThan(1));
      await tester.pumpAndSettle();
    });
  });
}

void _nada(int _) {}
