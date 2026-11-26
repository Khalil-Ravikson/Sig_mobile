import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/contraste_app.dart';
import '../../../../core/widgets/cartao_pressionavel.dart';
import '../turmas_view_model.dart';

/// Cartão da lista de turmas: disciplina, horário e 3 fichas (frequência,
/// última nota, próxima prova). Leva à turma virtual.
class CartaoTurma extends StatelessWidget {
  const CartaoTurma({super.key, required this.turma, required this.aoTocar});

  final TurmaUi turma;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        onTap: aoTocar,
        semanticsLabel:
            '${turma.disciplina}, ${turma.horario}. Frequência ${turma.frequencia}.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(turma.disciplina, style: AppText.subtitulo18),
                      const SizedBox(height: 2),
                      Text(turma.horario, style: AppText.corpo13),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s12),
                Icon(AppIcons.seta, size: 18, color: context.iconeSuave),
              ],
            ),
            const SizedBox(height: AppSpace.s12),
            Row(
              children: [
                Expanded(
                  child: _Ficha(valor: turma.frequencia, rotulo: 'Frequência'),
                ),
                const SizedBox(width: AppSpace.s8),
                Expanded(
                  child: _Ficha(valor: turma.ultimaNota, rotulo: 'Última nota'),
                ),
                const SizedBox(width: AppSpace.s8),
                Expanded(
                  child: _Ficha(
                    valor: turma.proximaProva,
                    rotulo: 'Próxima prova',
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

class _Ficha extends StatelessWidget {
  const _Ficha({required this.valor, required this.rotulo});

  final String valor;
  final String rotulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.tonal(AppColors.azulClaro),
        borderRadius: AppRadius.ficha,
        border: context.bordaContraste(),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: AppText.corpo15.copyWith(color: AppColors.azulAcao),
          ),
          const SizedBox(height: 2),
          // Encolhe um pouco em vez de cortar o rótulo ("Próxima prova").
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(rotulo, maxLines: 1, style: AppText.legenda11),
          ),
        ],
      ),
    );
  }
}
