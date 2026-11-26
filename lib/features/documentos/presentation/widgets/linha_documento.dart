import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/contraste_app.dart';
import '../../../../core/widgets/selo_situacao.dart';
import '../../domain/documento.dart';
import '../documentos_view_model.dart';

/// Uma linha da lista: tipo, título, subtítulo e, à direita, "Baixar" (mais
/// usados) ou o selo de estado (declarações). A linha inteira é tocável.
class LinhaDocumento extends StatelessWidget {
  const LinhaDocumento({
    super.key,
    required this.documento,
    required this.aoTocar,
  });

  final DocumentoUi documento;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final disponivel = documento.estado == EstadoDocumento.disponivel;
    final acao = documento.comBotaoBaixar
        ? 'baixar'
        : disponivel
        ? 'disponível'
        : 'sob pedido';
    return Semantics(
      button: true,
      label: '${documento.titulo}, ${documento.subtitulo}, $acao',
      excludeSemantics: true,
      onTap: aoTocar,
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(AppRadius.r14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.azulClaro,
                  borderRadius: BorderRadius.circular(AppRadius.r14),
                ),
                child: Text(
                  documento.tipo,
                  style: AppText.legenda11.copyWith(
                    color: AppColors.azulAcao,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documento.titulo,
                      style: AppText.corpo15.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      documento.subtitulo,
                      style: AppText.corpo13.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.s12),
              if (documento.comBotaoBaixar)
                const _BotaoBaixar()
              else if (disponivel)
                const SeloSituacao.sucesso('Disponível')
              else
                const SeloSituacao.aviso('Sob pedido'),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotaoBaixar extends StatelessWidget {
  const _BotaoBaixar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: context.tonal(AppColors.azulClaro),
        borderRadius: BorderRadius.circular(AppRadius.pilula),
        border: context.bordaContraste(),
      ),
      child: Text(
        'Baixar',
        style: AppText.corpo13.copyWith(
          color: AppColors.azulAcao,
          fontWeight: FontWeight.w600,
          height: 1.25,
        ),
      ),
    );
  }
}
