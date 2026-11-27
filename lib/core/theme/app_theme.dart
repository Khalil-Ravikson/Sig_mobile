import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static ThemeData claro() {
    final esquema = ColorScheme.fromSeed(seedColor: AppColors.marinho).copyWith(
      primary: AppColors.azulAcao,
      onPrimary: Colors.white,
      tertiary: AppColors.laranja,
      error: AppColors.erro,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      fontFamily: AppText.familia,
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
