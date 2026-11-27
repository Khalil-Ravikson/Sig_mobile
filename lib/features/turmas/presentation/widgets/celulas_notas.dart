import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/contraste_app.dart';
import '../../../../core/widgets/cartao_pressionavel.dart';
import '../turma_virtual_view_model.dart';

/// Cartão com as células N1, N2, N3 e Média.
class CartaoCelulasNotas extends StatelessWidget {
  const CartaoCelulasNotas({super.key, required this.celulas});

  final List<NotaUi> celulas;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        padding: const EdgeInsets.all(AppSpace.s12),
        child: Row(
          children: [
            for (var i = 0; i < celulas.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpace.s8),
              Expanded(child: _Celula(nota: celulas[i])),
            ],
          ],
        ),
      ),
    );
  }
}

class _Celula extends StatelessWidget {
  const _Celula({required this.nota});

  final NotaUi nota;

  @override
  Widget build(BuildContext context) {
    final corValor = nota.destaque
        ? AppColors.azulAcao
        : nota.lancada
        ? AppColors.marinho
        : AppColors.textoSecundario;
    return Semantics(
      label: nota.lancada
          ? '${nota.rotulo}: ${nota.valor}'
          : '${nota.rotulo}: ainda não lançada',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          decoration: BoxDecoration(
            color: context.tonal(
              nota.destaque ? AppColors.azulClaro : AppColors.fundoCampo,
            ),
            borderRadius: AppRadius.ficha,
            border: context.bordaContraste(),
          ),
          child: Column(
            children: [
              Text(
                nota.rotulo,
                style: AppText.legenda11.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                nota.valor,
                style: AppText.titulo24.copyWith(
                  fontSize: 20,
                  height: 1.3,
                  letterSpacing: 0,
                  color: corValor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
