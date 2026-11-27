import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Brasão da UEMA. Por enquanto é um círculo com a sigla; trocar pelo arquivo
/// oficial (SVG ou PNG com fundo transparente) quando a UEMA enviar.
class BrasaoUema extends StatelessWidget {
  const BrasaoUema({super.key, this.tamanho = 46});

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Brasão da UEMA',
      image: true,
      child: ExcludeSemantics(
        child: Container(
          width: tamanho,
          height: tamanho,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Text(
            'UEMA',
            style: TextStyle(
              fontSize: tamanho * 0.22,
              fontWeight: FontWeight.w700,
              color: AppColors.marinho,
            ),
          ),
        ),
      ),
    );
  }
}
