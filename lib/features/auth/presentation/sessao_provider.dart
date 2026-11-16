import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/resultado_login.dart';
import '../domain/sessao.dart';
import '../domain/vinculo.dart';
import 'auth_providers.dart';

class SessaoNotifier extends Notifier<Sessao> {
  @override
  Sessao build() => Sessao.vazia;

  /// Marca o login. O vínculo só fica escolhido depois que o token
  /// definitivo chega (ver `EscolhaVinculoViewModel`).
  void entrou(ResultadoLogin login) {
    state = Sessao(login: login);
  }

  void escolherVinculo(Vinculo vinculo) {
    state = Sessao(login: state.login, vinculo: vinculo);
  }

  void trocarVinculo() {
    state = Sessao(login: state.login);
  }

  /// Apaga o token guardado e limpa a sessão.
  Future<void> sair() async {
    await ref.read(authRepositoryProvider).sair();
    state = Sessao.vazia;
  }
}

final sessaoProvider = NotifierProvider<SessaoNotifier, Sessao>(
  SessaoNotifier.new,
);
