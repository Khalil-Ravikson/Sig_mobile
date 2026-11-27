import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/configuracoes.dart';

class ConfiguracoesNotifier extends Notifier<ConfiguracoesApp> {
  @override
  ConfiguracoesApp build() => const ConfiguracoesApp();

  void definirTamanhoTexto(TamanhoTexto valor) =>
      state = state.copyWith(tamanhoTexto: valor);

  void alternarAltoContraste() =>
      state = state.copyWith(altoContraste: !state.altoContraste);

  void alternarReduzirAnimacoes() =>
      state = state.copyWith(reduzirAnimacoes: !state.reduzirAnimacoes);

  void alternarDigital() =>
      state = state.copyWith(digitalLigada: !state.digitalLigada);
}

final configuracoesProvider =
    NotifierProvider<ConfiguracoesNotifier, ConfiguracoesApp>(
      ConfiguracoesNotifier.new,
    );
