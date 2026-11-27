import 'alpha_overrides.dart';
import 'bootstrap.dart';
import 'core/config/app_config.dart';

/// Alpha v0.0.1: protótipo navegável com dados fictícios em JSON local.
/// `flutter run --flavor dev -t lib/main_alpha.dart`
void main() => bootstrap(AppConfig.alpha(), overrides: alphaOverrides());
