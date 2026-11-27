import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/widgets/brilho_esqueleto.dart';

/// Esqueleto do corpo do Início (mesmas alturas do conteúdo real).
class EsqueletoInicio extends StatelessWidget {
  const EsqueletoInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return const BrilhoEsqueleto(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CaixaEsqueleto(altura: 174, raio: AppRadius.r24),
          SizedBox(height: AppSpace.s24),
          CaixaEsqueleto(largura: 180, altura: 26),
          SizedBox(height: AppSpace.s8),
          CaixaEsqueleto(altura: 168, raio: AppRadius.r24),
        ],
      ),
    );
  }
}
