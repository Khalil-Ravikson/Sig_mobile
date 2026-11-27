import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Estilos de texto do Figma (Public Sans). Cor padrão: marinho; troque com
/// `copyWith(color: ...)`.
abstract final class AppText {
  static const familia = 'PublicSans';

  /// Título/24 · Bold.
  static const titulo24 = TextStyle(
    fontFamily: familia,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.marinho,
  );

  /// Display/32 · Bold.
  static const display32 = TextStyle(
    fontFamily: familia,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.marinho,
  );

  /// Subtítulo/18 · SemiBold.
  static const subtitulo18 = TextStyle(
    fontFamily: familia,
    fontSize: 18,
    height: 26 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.marinho,
  );

  /// Corpo/15 · Regular.
  static const corpo15 = TextStyle(
    fontFamily: familia,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
    color: AppColors.marinho,
  );

  /// Corpo pequeno/13 · Regular.
  static const corpo13 = TextStyle(
    fontFamily: familia,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textoSecundario,
  );

  /// Legenda/11 · SemiBold.
  static const legenda11 = TextStyle(
    fontFamily: familia,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.textoSecundario,
  );
}
