import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/contraste_app.dart';
import '../theme/motion.dart';

/// Interruptor do Figma (50 × 28): trilho azul de ação quando ligado, cinza
/// quando desligado; a bolinha branca desliza. É só o desenho: quem o usa
/// (uma `LinhaMenu`) cuida do toque e da semântica.
class Interruptor extends StatelessWidget {
  const Interruptor({super.key, required this.ligado});

  final bool ligado;

  @override
  Widget build(BuildContext context) {
    final duracao = Motion.duracao(context, Motion.rapido);
    return AnimatedContainer(
      duration: duracao,
      curve: Motion.entrada,
      width: 50,
      height: 28,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: ligado ? AppColors.azulAcao : context.fio,
        borderRadius: BorderRadius.circular(999),
      ),
      child: AnimatedAlign(
        duration: duracao,
        curve: Motion.entrada,
        alignment: ligado ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.branco,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
