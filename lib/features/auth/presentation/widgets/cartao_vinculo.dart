import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/vinculo.dart';
import '../tipo_vinculo_texto.dart';

/// Cartão de um vínculo na tela de escolha (Figma ACE-02 A).
class CartaoVinculo extends StatelessWidget {
  const CartaoVinculo({super.key, required this.vinculo, required this.onTap});

  final Vinculo vinculo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${vinculo.tipo.titulo}, ${vinculo.descricao}',
      child: ExcludeSemantics(
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borda),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.fundoHero,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      vinculo.tipo.icone,
                      size: 22,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vinculo.tipo.titulo,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.tinta,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vinculo.descricao,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textoSecundario,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '›',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
