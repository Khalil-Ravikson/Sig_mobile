import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

/// Forma decorativa do canto do cabeçalho.
enum DecoracaoCabecalho {
  /// Círculo grande (Início, Turmas).
  circulo,

  /// Quadrado de cantos redondos, inclinado 18° (Perfil e telas filhas).
  quadradoInclinado,

  nenhuma,
}

/// Fundo marinho dos cabeçalhos: curva `radius/40` embaixo, filete laranja de
/// 3 px e a decoração do canto. O conteúdo vai em [child], já com o padding
/// que a tela escolher.
class FundoCabecalho extends StatelessWidget {
  const FundoCabecalho({
    super.key,
    required this.child,
    this.decoracao = DecoracaoCabecalho.circulo,
  });

  static const curva = BorderRadius.vertical(
    bottom: Radius.circular(AppRadius.r40),
  );

  final Widget child;
  final DecoracaoCabecalho decoracao;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.marinho,
        borderRadius: curva,
        boxShadow: AppShadows.filete,
      ),
      child: ClipRRect(
        borderRadius: curva,
        child: Stack(
          children: [
            ...switch (decoracao) {
              DecoracaoCabecalho.circulo => [
                const Positioned(
                  right: -119,
                  top: -120,
                  width: 300,
                  height: 300,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.marinhoClaro,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
              DecoracaoCabecalho.quadradoInclinado => [
                Positioned(
                  right: 6,
                  top: -13,
                  width: 130,
                  height: 130,
                  child: Transform.rotate(
                    angle: 18 * 3.1415926535 / 180,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.marinhoClaro,
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                    ),
                  ),
                ),
              ],
              DecoracaoCabecalho.nenhuma => const <Widget>[],
            },
            child,
          ],
        ),
      ),
    );
  }
}
