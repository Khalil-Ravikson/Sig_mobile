import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/widgets/brilho_esqueleto.dart';

/// Esqueleto da lista de turmas.
class EsqueletoTurmas extends StatelessWidget {
  const EsqueletoTurmas({super.key});

  @override
  Widget build(BuildContext context) {
    return const BrilhoEsqueleto(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CaixaEsqueleto(largura: 110, altura: 26),
          SizedBox(height: AppSpace.s16),
          CaixaEsqueleto(altura: 160, raio: AppRadius.r24),
          SizedBox(height: AppSpace.s16),
          CaixaEsqueleto(altura: 160, raio: AppRadius.r24),
        ],
      ),
    );
  }
}
