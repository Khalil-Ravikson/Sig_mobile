import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Sombras do Flat 2.0.
abstract final class AppShadows {
  /// Cartão branco: y 4, desfoque 16, 8% de azul-marinho.
  static const cartao = [
    BoxShadow(color: Color(0x140F1E45), offset: Offset(0, 4), blurRadius: 16),
  ];

  /// Filete laranja do cabeçalho: sombra sólida de 3 px, sem desfoque.
  static const filete = [
    BoxShadow(color: AppColors.laranja, offset: Offset(0, 3)),
  ];

  /// Brilho azul da bolha da barra inferior.
  static const bolha = [
    BoxShadow(color: Color(0x592C46C9), offset: Offset(0, 4), blurRadius: 12),
  ];
}
