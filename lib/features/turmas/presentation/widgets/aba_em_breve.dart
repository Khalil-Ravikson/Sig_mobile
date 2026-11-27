import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/widgets/cartao_pressionavel.dart';
import '../aba_turma.dart';

/// Materiais e Atividades: fase 2, fora do alpha.
class AbaEmBreve extends StatelessWidget {
  const AbaEmBreve({super.key, required this.aba});

  final AbaTurma aba;

  @override
  Widget build(BuildContext context) {
    final icone = aba == AbaTurma.materiais
        ? AppIcons.materiais
        : AppIcons.atividades;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpace.margemTela,
        AppSpace.s16,
        AppSpace.margemTela,
        AppSpace.s32 + MediaQuery.paddingOf(context).bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        child: CartaoPressionavel(
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.azulClaro,
                  borderRadius: AppRadius.ficha,
                ),
                child: Icon(icone, size: 22, color: AppColors.azulAcao),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${aba.rotulo} chegam em breve',
                      style: AppText.corpo15.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Esta área fica para a fase 2 do app.',
                      style: AppText.corpo13,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
