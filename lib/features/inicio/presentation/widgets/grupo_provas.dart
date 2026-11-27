import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/contraste_app.dart';
import '../../../../core/widgets/cartao_pressionavel.dart';
import '../../../../core/widgets/conteudo_assincrono.dart';
import '../inicio_view_model.dart';

/// "Provas e atividades": título, "Ver tudo" e o cartão com as próximas.
class GrupoProvas extends StatelessWidget {
  const GrupoProvas({super.key, required this.provas, required this.aoVerTudo});

  final List<ProvaUi> provas;
  final VoidCallback aoVerTudo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Provas e atividades', style: AppText.subtitulo18),
            ),
            TextButton(
              onPressed: aoVerTudo,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.azulAcao,
                minimumSize: const Size(AppSpace.alvoToque, AppSpace.alvoToque),
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s8),
                textStyle: AppText.corpo13,
              ),
              child: const Text('Ver tudo'),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.s8),
        SizedBox(
          width: double.infinity,
          child: CartaoPressionavel(
            child: provas.isEmpty
                ? const EstadoVazio(
                    mensagem: 'Nenhuma prova ou atividade marcada.',
                  )
                : Column(
                    children: [
                      for (var i = 0; i < provas.length; i++) ...[
                        if (i > 0) const SizedBox(height: AppSpace.s16),
                        _LinhaProva(prova: provas[i]),
                      ],
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _LinhaProva extends StatelessWidget {
  const _LinhaProva({required this.prova});

  final ProvaUi prova;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${prova.titulo}, ${prova.dia} de ${prova.mes}, ${prova.quando}',
      child: ExcludeSemantics(
        child: Row(
          children: [
            Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: AppSpace.s8),
              decoration: BoxDecoration(
                color: context.tonal(AppColors.azulClaro),
                borderRadius: AppRadius.ficha,
                border: context.bordaContraste(),
              ),
              child: Column(
                children: [
                  Text(
                    prova.dia,
                    style: AppText.subtitulo18.copyWith(
                      color: AppColors.azulAcao,
                    ),
                  ),
                  Text(
                    prova.mes,
                    style: AppText.legenda11.copyWith(
                      color: AppColors.azulAcao,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prova.titulo, style: AppText.corpo15),
                  const SizedBox(height: 2),
                  Text(prova.quando, style: AppText.corpo13),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
