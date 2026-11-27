import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/util/formato_data.dart';
import '../../../../core/widgets/anel_progresso.dart';
import '../../../../core/widgets/cartao_pressionavel.dart';
import '../../../../core/widgets/numero_animado.dart';

/// Herói do Início: integralização do curso (anel) e CR.
class CartaoResumoSemestre extends StatelessWidget {
  const CartaoResumoSemestre({
    super.key,
    required this.integralizacao,
    required this.cr,
  });

  /// 0 a 100.
  final int integralizacao;
  final double cr;

  @override
  Widget build(BuildContext context) {
    return CartaoPressionavel(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resumo do semestre', style: AppText.corpo13),
            const SizedBox(height: AppSpace.s12),
            Row(
              children: [
                AnelProgresso(
                  valor: integralizacao / 100,
                  rotuloSemantico: 'Integralização do curso',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NumeroAnimado(
                        valor: integralizacao.toDouble(),
                        formatar: (v) => '${v.round()}%',
                        estilo: AppText.titulo24.copyWith(
                          color: AppColors.azulAcao,
                        ),
                      ),
                      const Text('do curso', style: AppText.legenda11),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NumeroAnimado(
                        valor: cr,
                        formatar: FormatoData.duasCasas,
                        estilo: AppText.display32,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'CR (coeficiente de rendimento)',
                        style: AppText.legenda11,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
