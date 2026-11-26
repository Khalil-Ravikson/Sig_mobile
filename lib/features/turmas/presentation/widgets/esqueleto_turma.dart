import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/widgets/brilho_esqueleto.dart';

/// Esqueleto do corpo da turma virtual.
class EsqueletoTurma extends StatelessWidget {
  const EsqueletoTurma({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSpace.margemTela,
        AppSpace.s16,
        AppSpace.margemTela,
        0,
      ),
      child: BrilhoEsqueleto(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CaixaEsqueleto(altura: 152, raio: AppRadius.r24),
            SizedBox(height: AppSpace.s16),
            CaixaEsqueleto(largura: 70, altura: 22),
            SizedBox(height: AppSpace.s16),
            CaixaEsqueleto(altura: 92, raio: AppRadius.r24),
            SizedBox(height: AppSpace.s16),
            CaixaEsqueleto(altura: 92, raio: AppRadius.r24),
          ],
        ),
      ),
    );
  }
}
