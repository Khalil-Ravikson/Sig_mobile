import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/config/app_config_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/resultado_login.dart';
import 'features/auth/domain/vinculo.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/vinculo_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    return MaterialApp(
      title: config.nomeApp,
      debugShowCheckedModeBanner: config.ambiente != Ambiente.producao,
      theme: AppTheme.claro(),
      home: Builder(
        builder: (context) {
          final nav = Navigator.of(context);

          void entrarComo(Vinculo v) =>
              nav.push(MaterialPageRoute<void>(builder: (_) => _Entrando(v)));

          // Com um só vínculo a escolha é pulada.
          void aposLogin(ResultadoLogin r) {
            if (r.vinculos.length == 1) {
              entrarComo(r.vinculos.single);
              return;
            }
            nav.push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    VinculoPage(resultado: r, onEscolher: entrarComo),
              ),
            );
          }

          return LoginPage(onEntrou: aposLogin);
        },
      ),
    );
  }
}

/// Provisório: a Home substitui esta tela.
class _Entrando extends StatelessWidget {
  const _Entrando(this.vinculo);

  final Vinculo vinculo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Entrando como ${vinculo.descricao}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
