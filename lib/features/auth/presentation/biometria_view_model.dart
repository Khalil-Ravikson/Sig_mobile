import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/biometria.dart';
import 'auth_providers.dart';

part 'biometria_view_model.g.dart';

enum FaseBiometria {
  inicial,
  autenticando,
  sucesso,
  naoReconhecida,
  bloqueada,
  indisponivel,
}

/// Estado da tela de "quem volta": pede a digital e traduz o resultado.
@riverpod
class BiometriaViewModel extends _$BiometriaViewModel {
  @override
  FaseBiometria build() => FaseBiometria.inicial;

  Future<void> autenticar() async {
    if (state == FaseBiometria.autenticando) return;
    state = FaseBiometria.autenticando;
    final resultado = await ref
        .read(biometriaProvider)
        .autenticar(motivo: 'Entrar no SIGUEMA');
    if (!ref.mounted) return;

    state = switch (resultado) {
      ResultadoBiometria.sucesso => FaseBiometria.sucesso,
      ResultadoBiometria.naoReconhecida => FaseBiometria.naoReconhecida,
      ResultadoBiometria.bloqueada => FaseBiometria.bloqueada,
      ResultadoBiometria.indisponivel => FaseBiometria.indisponivel,
      // Fechar a janela do sistema não é erro: volta ao começo.
      ResultadoBiometria.cancelada => FaseBiometria.inicial,
    };
  }
}
