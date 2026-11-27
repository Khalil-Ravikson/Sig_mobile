import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Cartão "Precisa de ajuda?" mostrado quando o login dá erro.
class CartaoAjuda extends StatelessWidget {
  const CartaoAjuda({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borda),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Precisa de ajuda?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.tinta,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Dúvidas de uso: coordenação do seu curso. '
            'Erros do sistema: nti@uema.br, informando o CPF.',
            style: TextStyle(fontSize: 12, color: AppColors.textoSecundario),
          ),
        ],
      ),
    );
  }
}
