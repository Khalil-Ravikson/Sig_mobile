import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/widgets/brilho_esqueleto.dart';

/// Esqueleto da lista de documentos.
class EsqueletoDocumentos extends StatelessWidget {
  const EsqueletoDocumentos({super.key});

  @override
  Widget build(BuildContext context) {
    return const BrilhoEsqueleto(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CaixaEsqueleto(largura: 110, altura: 22),
          SizedBox(height: AppSpace.s16),
          CaixaEsqueleto(altura: 232, raio: AppRadius.r24),
          SizedBox(height: AppSpace.s16),
          CaixaEsqueleto(largura: 180, altura: 22),
          SizedBox(height: AppSpace.s16),
          CaixaEsqueleto(altura: 152, raio: AppRadius.r24),
        ],
      ),
    );
  }
}
