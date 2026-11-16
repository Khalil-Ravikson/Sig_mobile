/// Resultado de pedir a digital (ou o rosto) ao aparelho.
enum ResultadoBiometria {
  sucesso,

  /// A digital não bateu. Dá para tentar de novo.
  naoReconhecida,

  /// A pessoa fechou a janela do sistema. Não é erro.
  cancelada,

  /// O aparelho bloqueou a biometria por excesso de tentativas.
  bloqueada,

  /// Sem sensor, sem digital cadastrada ou sem tela de bloqueio.
  indisponivel,
}

/// Biometria do aparelho. O app só pede e recebe o resultado: quem decide o
/// número de tentativas e o bloqueio é o sistema do celular.
abstract interface class Biometria {
  /// O aparelho tem sensor e ao menos uma biometria cadastrada.
  Future<bool> disponivel();

  Future<ResultadoBiometria> autenticar({required String motivo});
}
