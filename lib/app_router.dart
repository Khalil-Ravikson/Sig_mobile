import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/domain/sessao.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/sessao_provider.dart';
import 'features/auth/presentation/vinculo_page.dart';
import 'features/home/presentation/home_page.dart';

abstract final class Rotas {
  static const login = '/login';
  static const vinculo = '/vinculo';
  static const home = '/home';
}

/// Decide para onde a pessoa vai conforme a sessão: sem login → login;
/// logada sem vínculo → escolha; com vínculo → home. `null` = ficar.
String? redirecionarPorSessao(Sessao sessao, String local) {
  if (!sessao.logado) return local == Rotas.login ? null : Rotas.login;
  if (!sessao.vinculoEscolhido) {
    return local == Rotas.vinculo ? null : Rotas.vinculo;
  }
  return local == Rotas.home ? null : Rotas.home;
}

final routerProvider = Provider<GoRouter>((ref) {
  // Avisa o router quando a sessão muda, para ele refazer o redirecionamento.
  final mudou = ValueNotifier<int>(0);
  ref.listen(sessaoProvider, (_, _) => mudou.value++);

  final router = GoRouter(
    initialLocation: Rotas.login,
    refreshListenable: mudou,
    redirect: (context, state) =>
        redirecionarPorSessao(ref.read(sessaoProvider), state.matchedLocation),
    routes: [
      GoRoute(
        path: Rotas.login,
        builder: (context, state) => LoginPage(
          onEntrou: (login) => ref.read(sessaoProvider.notifier).entrou(login),
        ),
      ),
      GoRoute(
        path: Rotas.vinculo,
        builder: (context, state) {
          final login = ref.read(sessaoProvider).login;
          if (login == null) return const SizedBox.shrink();
          return VinculoPage(
            resultado: login,
            onEscolher: (v) =>
                ref.read(sessaoProvider.notifier).escolherVinculo(v),
          );
        },
      ),
      GoRoute(path: Rotas.home, builder: (context, state) => const HomePage()),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    mudou.dispose();
  });
  return router;
});
