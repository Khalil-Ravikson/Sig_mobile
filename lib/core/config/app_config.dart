/// Ambientes do app. Cada entrada (`main_*.dart`) escolhe um.
enum Ambiente { dev, homologacao, producao }

/// Configuração por ambiente. Sem segredos: só valores públicos.
///
/// A URL base pode ser sobrescrita no build com
/// `--dart-define=API_BASE_URL=https://...`.
class AppConfig {
  const AppConfig({
    required this.ambiente,
    required this.apiBaseUrl,
    required this.nomeApp,
  });

  final Ambiente ambiente;
  final String apiBaseUrl;
  final String nomeApp;

  static const _urlDefinida = String.fromEnvironment('API_BASE_URL');

  /// Mock local (Docker). `10.0.2.2` é o PC visto pelo emulador Android.
  factory AppConfig.dev() => AppConfig(
    ambiente: Ambiente.dev,
    apiBaseUrl: _urlDefinida.isNotEmpty ? _urlDefinida : 'http://10.0.2.2:4010',
    nomeApp: 'SIGUEMA Dev',
  );

  /// URL provisória (`.invalid` nunca resolve) até a CTIC informar o endereço.
  factory AppConfig.homologacao() => AppConfig(
    ambiente: Ambiente.homologacao,
    apiBaseUrl: _urlDefinida.isNotEmpty
        ? _urlDefinida
        : 'https://api-homologacao.siguema.invalid',
    nomeApp: 'SIGUEMA Hml',
  );

  /// URL provisória até a CTIC informar o endereço.
  factory AppConfig.producao() => AppConfig(
    ambiente: Ambiente.producao,
    apiBaseUrl: _urlDefinida.isNotEmpty
        ? _urlDefinida
        : 'https://api.siguema.invalid',
    nomeApp: 'SIGUEMA',
  );
}
