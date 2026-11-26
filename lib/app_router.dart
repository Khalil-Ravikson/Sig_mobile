import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/widgets/transicao_pagina.dart';
import 'features/ajuda/presentation/ajuda_page.dart';
import 'features/auth/domain/sessao.dart';
import 'features/auth/domain/vinculo.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/sessao_provider.dart';
import 'features/auth/presentation/vinculo_page.dart';
import 'features/documentos/presentation/documentos_page.dart';
import 'features/inicio/presentation/inicio_page.dart';
import 'features/perfil/presentation/configuracoes_page.dart';
import 'features/perfil/presentation/meus_dados_page.dart';
import 'features/perfil/presentation/perfil_page.dart';
import 'features/shell/presentation/paginas_provisorias.dart';
import 'features/shell/presentation/shell_page.dart';
import 'features/shell/presentation/widgets/container_abas.dart';
import 'features/turmas/presentation/aba_turma.dart';
import 'features/turmas/presentation/turma_page.dart';
import 'features/turmas/presentation/turmas_page.dart';
import 'rotas.dart';

export 'rotas.dart';

/// Decide para onde a pessoa vai conforme a sessão: sem login → login;
/// logada sem vínculo → escolha; com vínculo → Início (e fora das telas de
/// acesso, fica onde está). `null` = ficar.
String? redirecionarPorSessao(Sessao sessao, String local) {
  if (!sessao.logado) return local == Rotas.login ? null : Rotas.login;
  if (!sessao.vinculoEscolhido) {
    return local == Rotas.vinculo ? null : Rotas.vinculo;
  }
  final emTelaDeAcesso = local == Rotas.login || local == Rotas.vinculo;
  return emTelaDeAcesso || local == '/' ? Rotas.inicio : null;
}

final _navegadorRaiz = GlobalKey<NavigatorState>(debugLabel: 'raiz');

final routerProvider = Provider<GoRouter>((ref) {
  // Avisa o router quando a sessão muda, para ele refazer o redirecionamento.
  final mudou = ValueNotifier<int>(0);
  ref.listen(sessaoProvider, (_, _) => mudou.value++);

  final router = GoRouter(
    navigatorKey: _navegadorRaiz,
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
            onSair: () => ref.read(sessaoProvider.notifier).sair(),
          );
        },
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) {
          // O alpha só tem o discente; os outros vínculos veem "em breve".
          final tipo = ref.read(sessaoProvider).vinculo?.tipo;
          if (tipo != null && tipo != TipoVinculo.aluno) {
            return const VinculoEmBreveProvisorioPage();
          }
          return ShellPage(navigationShell: navigationShell);
        },
        navigatorContainerBuilder: (context, navigationShell, abas) =>
            ContainerAbas(indice: navigationShell.currentIndex, abas: abas),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Rotas.inicio,
                builder: (context, state) => const InicioPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Rotas.turmas,
                builder: (context, state) => const TurmasPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _navegadorRaiz,
                    // Chave fixa: trocar `?aba=` só atualiza a página, sem nova
                    // transição.
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return paginaSuave<void>(
                        key: ValueKey('turma-$id'),
                        child: TurmaPage(
                          id: id,
                          aba: AbaTurma.ler(state.uri.queryParameters['aba']),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Rotas.documentos,
                builder: (context, state) => const DocumentosPage(),
              ),
            ],
          ),
        ],
      ),
      // Perfil e as telas filhas abrem por cima das abas (sem barra).
      GoRoute(
        path: Rotas.perfil,
        parentNavigatorKey: _navegadorRaiz,
        pageBuilder: (context, state) =>
            paginaSuave<void>(key: state.pageKey, child: const PerfilPage()),
        routes: [
          GoRoute(
            path: 'dados',
            parentNavigatorKey: _navegadorRaiz,
            pageBuilder: (context, state) => paginaSuave<void>(
              key: state.pageKey,
              child: const MeusDadosPage(),
            ),
          ),
          GoRoute(
            path: 'config',
            parentNavigatorKey: _navegadorRaiz,
            pageBuilder: (context, state) => paginaSuave<void>(
              key: state.pageKey,
              child: const ConfiguracoesPage(),
            ),
          ),
          GoRoute(
            path: 'ajuda',
            parentNavigatorKey: _navegadorRaiz,
            pageBuilder: (context, state) =>
                paginaSuave<void>(key: state.pageKey, child: const AjudaPage()),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    mudou.dispose();
  });
  return router;
});
