import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Avatar com as iniciais; abre o menu da conta (Trocar vínculo, Sair).
class MenuConta extends StatelessWidget {
  const MenuConta({
    super.key,
    required this.iniciais,
    required this.podeTrocarVinculo,
    required this.onTrocarVinculo,
    required this.onSair,
  });

  final String iniciais;
  final bool podeTrocarVinculo;
  final VoidCallback onTrocarVinculo;
  final VoidCallback onSair;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Menu da conta',
      onSelected: (valor) => valor == 'trocar' ? onTrocarVinculo() : onSair(),
      itemBuilder: (_) => [
        if (podeTrocarVinculo)
          const PopupMenuItem(value: 'trocar', child: Text('Trocar vínculo')),
        const PopupMenuItem(value: 'sair', child: Text('Sair')),
      ],
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.borda,
          shape: BoxShape.circle,
        ),
        child: Text(
          iniciais,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.tinta,
          ),
        ),
      ),
    );
  }
}
