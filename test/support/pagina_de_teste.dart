import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/config/sem_novas_tentativas.dart';
import 'package:siguema_mobile/core/mock/mock_providers.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/auth/domain/resultado_login.dart';
import 'package:siguema_mobile/features/auth/presentation/sessao_provider.dart';
import 'package:siguema_mobile/features/turmas/domain/semestre_repository.dart';
import 'package:siguema_mobile/features/turmas/presentation/resumo_semestre_provider.dart';

import 'fakes_semestre.dart';

/// Monta uma tela sozinha (sem router) com a sessão de "Ana" e um
/// repositório falso, no tamanho de um celular.
Future<ProviderContainer> abrirPagina(
  WidgetTester tester,
  Widget pagina, {
  required SemestreRepository repositorio,
  bool reduzirAnimacoes = false,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    retry: semNovasTentativas,
    overrides: <Override>[
      semestreRepositoryProvider.overrideWithValue(repositorio),
      relogioProvider.overrideWithValue(relogioDeTeste),
    ],
  );
  addTearDown(container.dispose);
  container
      .read(sessaoProvider.notifier)
      .entrou(
        const ResultadoLogin(
          nome: 'Ana Exemplo Souza',
          vinculos: [],
          tokenTemporario: 't',
        ),
      );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.claro(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: reduzirAnimacoes),
          child: child!,
        ),
        home: Scaffold(body: pagina),
      ),
    ),
  );
  return container;
}
