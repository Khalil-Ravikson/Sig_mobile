import 'package:local_auth/local_auth.dart';

import '../domain/biometria.dart';

/// Biometria real, pelo `local_auth` (BiometricPrompt no Android, Face ID e
/// Touch ID no iOS). Não dá para testar sem aparelho: os testes usam um fake.
class BiometriaLocalAuth implements Biometria {
  BiometriaLocalAuth([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> disponivel() async {
    try {
      if (!await _auth.isDeviceSupported()) return false;
      return (await _auth.getAvailableBiometrics()).isNotEmpty;
    } on Object {
      return false;
    }
  }

  @override
  Future<ResultadoBiometria> autenticar({required String motivo}) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: motivo,
        biometricOnly: true,
      );
      return ok
          ? ResultadoBiometria.sucesso
          : ResultadoBiometria.naoReconhecida;
    } on LocalAuthException catch (e) {
      return mapearCodigo(e.code);
    } on Object {
      return ResultadoBiometria.indisponivel;
    }
  }

  /// Traduz o erro do plugin para o que o app entende.
  static ResultadoBiometria mapearCodigo(LocalAuthExceptionCode codigo) =>
      switch (codigo) {
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled ||
        LocalAuthExceptionCode.timeout ||
        LocalAuthExceptionCode.authInProgress => ResultadoBiometria.cancelada,
        LocalAuthExceptionCode.temporaryLockout ||
        LocalAuthExceptionCode.biometricLockout => ResultadoBiometria.bloqueada,
        _ => ResultadoBiometria.indisponivel,
      };
}
