import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:siguema_mobile/alpha_overrides.dart';
import 'package:siguema_mobile/core/config/sem_novas_tentativas.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';
import 'package:siguema_mobile/core/mock/mock_providers.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/turmas/data/json_semestre_repository.dart';
import 'package:siguema_mobile/features/turmas/data/json_turma_repository.dart';
import 'package:siguema_mobile/features/turmas/presentation/aba_turma.dart';
import 'package:siguema_mobile/features/turmas/presentation/resumo_semestre_provider.dart';
import 'package:siguema_mobile/features/turmas/presentation/turma_page.dart';
import 'package:siguema_mobile/features/turmas/presentation/turma_providers.dart';

import 'arquivos_bundle.dart';

/// Overrides do alpha lendo os JSON de verdade, sem espera simulada.
List<Override> overridesDoAlpha({Map<String, int>? leituras}) => <Override>[
  ...alphaOverrides(),
  assetBundleProvider.overrideWithValue(ArquivosBundle(leituras: leituras)),
  latenciaProvider.overrideWithValue(FonteJson.semLatencia),
];

/// O mesmo que [overridesDoAlpha], mas sem o repositório de frequência, para o
/// teste pôr o seu (o Riverpod não aceita o mesmo override duas vezes).
List<Override> overridesDoAlphaSemFrequencia() => <Override>[
  semestreRepositoryProvider.overrideWith(
    (ref) => JsonSemestreRepository(ref.watch(fonteJsonProvider)),
  ),
  turmaRepositoryProvider.overrideWith(
    (ref) => JsonTurmaRepository(ref.watch(fonteJsonProvider)),
  ),
  relogioProvider.overrideWithValue(relogioDoAlpha),
  assetBundleProvider.overrideWithValue(ArquivosBundle()),
  latenciaProvider.overrideWithValue(FonteJson.semLatencia),
];

/// Abre a turma virtual num router mínimo (rota `/turmas/:id?aba=`), com um
/// `/turmas` vazio por baixo para o voltar. Devolve o router para conferir
/// a URL.
Future<GoRouter> abrirTurma(
  WidgetTester tester,
  String localizacao, {
  bool reduzirAnimacoes = false,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/turmas',
    routes: [
      GoRoute(
        path: '/turmas',
        builder: (context, state) => const Scaffold(body: Text('Lista')),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => TurmaPage(
              id: state.pathParameters['id']!,
              aba: AbaTurma.ler(state.uri.queryParameters['aba']),
            ),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      retry: semNovasTentativas,
      overrides: overridesDoAlpha(),
      child: MaterialApp.router(
        theme: AppTheme.claro(),
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: reduzirAnimacoes),
          child: child!,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  router.go(localizacao);
  await tester.pumpAndSettle();
  return router;
}
