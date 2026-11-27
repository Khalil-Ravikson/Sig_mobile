import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/motion.dart';

/// Foto de perfil do topo (por enquanto, as iniciais). Leva ao Perfil com um
/// `Hero`: o círculo "voa" até a tela de destino, que usa a mesma [tagHero].
class AvatarPerfil extends StatelessWidget {
  const AvatarPerfil({
    super.key,
    required this.iniciais,
    this.tamanho = 48,
    this.onTap,
  });

  static const tagHero = 'foto-perfil';

  final String iniciais;
  final double tamanho;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final circulo = _MaybeHero(
      voar: !Motion.reduzir(context),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: tamanho,
          height: tamanho,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.azulClaro,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.branco,
              width: tamanho > 60 ? 3 : 2,
            ),
          ),
          child: Text(
            iniciais,
            style: AppText.subtitulo18.copyWith(
              color: AppColors.azulAcao,
              fontSize: tamanho > 60 ? 28 : tamanho * 0.34,
              height: 1,
            ),
          ),
        ),
      ),
    );
    return Semantics(
      button: onTap != null,
      label: 'Abrir perfil',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: circulo,
      ),
    );
  }
}

/// `Hero` só quando o movimento não está reduzido (sem "voo" da foto).
class _MaybeHero extends StatelessWidget {
  const _MaybeHero({required this.voar, required this.child});

  final bool voar;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      voar ? Hero(tag: AvatarPerfil.tagHero, child: child) : child;
}
