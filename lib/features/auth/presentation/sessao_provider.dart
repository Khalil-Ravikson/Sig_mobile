import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/resultado_login.dart';
import '../domain/sessao.dart';
import '../domain/vinculo.dart';

class SessaoNotifier extends Notifier<Sessao> {
  @override
  Sessao build() => Sessao.vazia;

  /// Com um só vínculo, ele já fica escolhido e a tela de escolha é pulada.
  void entrou(ResultadoLogin login) {
    state = Sessao(
      login: login,
      vinculo: login.vinculos.length == 1 ? login.vinculos.single : null,
    );
  }

  void escolherVinculo(Vinculo vinculo) {
    state = Sessao(login: state.login, vinculo: vinculo);
  }

  void trocarVinculo() {
    state = Sessao(login: state.login);
  }

  void sair() {
    state = Sessao.vazia;
  }
}

final sessaoProvider = NotifierProvider<SessaoNotifier, Sessao>(
  SessaoNotifier.new,
);
