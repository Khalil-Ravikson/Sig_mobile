import 'package:flutter/widgets.dart';

/// Raios do Figma (`SIGUEMA / Medidas`).
abstract final class AppRadius {
  static const double r8 = 8;
  static const double r12 = 12;
  static const double r14 = 14;
  static const double r16 = 16;
  static const double r24 = 24;
  static const double r28 = 28;

  /// Curva do cabeçalho nas telas do app.
  static const double r40 = 40;
  static const double pilula = 999;

  static const cartao = BorderRadius.all(Radius.circular(r24));
  static const ficha = BorderRadius.all(Radius.circular(r16));
  static const chip = BorderRadius.all(Radius.circular(r28));
}
