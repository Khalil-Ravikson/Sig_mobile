import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData claro() {
    final esquema = ColorScheme.fromSeed(
      seedColor: AppColors.tinta,
    ).copyWith(primary: AppColors.tinta, error: AppColors.erro);
    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
