import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/theme/app_colors.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';

void main() {
  test('o tema usa o azul de ação como cor primária e o laranja de acento', () {
    final tema = AppTheme.claro();
    expect(tema.useMaterial3, isTrue);
    expect(tema.colorScheme.primary, AppColors.azulAcao);
    expect(tema.colorScheme.tertiary, AppColors.laranja);
    expect(tema.colorScheme.error, AppColors.erro);
  });
}
