import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Faixa de abertura do login: brasão (placeholder), nome e descrição.
class HeroLogin extends StatelessWidget {
  const HeroLogin({super.key});

  static const altura = 290.0;

  @override
  Widget build(BuildContext context) {
    final topo = MediaQuery.paddingOf(context).top;
    return ClipRect(
      child: Container(
        color: AppColors.fundoHero,
        height: altura + topo,
        width: double.infinity,
        child: Stack(
          children: [
            const Positioned(
              right: -67,
              top: -70,
              child: _Circulo(tamanho: 220, cor: AppColors.borda),
            ),
            const Positioned(
              left: -30,
              bottom: -40,
              child: _Circulo(tamanho: 120, cor: AppColors.textoSuave),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(28, topo + 24, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Circulo(tamanho: 56, cor: AppColors.tinta),
                  const SizedBox(height: 10),
                  const Text(
                    'SIGUEMA',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tinta,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sistema Integrado de Gestão de Atividades Acadêmicas · '
                    'UEMA',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circulo extends StatelessWidget {
  const _Circulo({required this.tamanho, required this.cor});

  final double tamanho;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
      ),
    );
  }
}
