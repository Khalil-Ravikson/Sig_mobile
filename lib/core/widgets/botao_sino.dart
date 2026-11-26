import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_space.dart';

/// Sino de notificações do cabeçalho (44 × 44). Único ponto de entrada das
/// notificações; o ponto laranja indica novidade.
class BotaoSino extends StatelessWidget {
  const BotaoSino({super.key, this.comPonto = false, this.onTap});

  final bool comPonto;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: comPonto ? 'Notificações, há novidades' : 'Notificações',
      child: SizedBox(
        width: AppSpace.alvoToque,
        height: AppSpace.alvoToque,
        child: Material(
          color: AppColors.marinhoClaro,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(AppIcons.sino, size: 22, color: AppColors.branco),
                if (comPonto)
                  Positioned(
                    top: 10,
                    right: 11,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.laranja,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
