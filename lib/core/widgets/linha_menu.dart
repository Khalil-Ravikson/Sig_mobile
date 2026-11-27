import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_text.dart';
import '../theme/contraste_app.dart';

/// Cartão branco de lista (padding 8) com um fio de 1 px entre as linhas.
class CartaoLista extends StatelessWidget {
  const CartaoLista({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: AppRadius.cartao,
        boxShadow: context.sombraCartao,
        border: context.bordaContraste(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) Divider(height: 1, thickness: 1, color: context.fio),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// Linha de menu: ícone num quadrado tonal, título, apoio opcional e, à
/// direita, uma seta (ou o [trailing]). A linha inteira é tocável.
class LinhaMenu extends StatelessWidget {
  const LinhaMenu({
    super.key,
    required this.icone,
    required this.titulo,
    this.subtitulo,
    this.trailing,
    this.aoTocar,
    this.paddingVertical = 12,
    this.raioIcone = AppRadius.r14,
    this.semanticaExtra,
  });

  final IconData icone;
  final String titulo;
  final String? subtitulo;

  /// Troca a seta (ex.: um interruptor).
  final Widget? trailing;
  final VoidCallback? aoTocar;
  final double paddingVertical;

  /// 14 nas configurações, 16 no menu do Perfil (Figma).
  final double raioIcone;

  /// Texto extra para leitores de tela (ex.: "ligado").
  final String? semanticaExtra;

  @override
  Widget build(BuildContext context) {
    final conteudo = Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.azulClaro,
              borderRadius: BorderRadius.circular(raioIcone),
            ),
            child: Icon(icone, size: 22, color: AppColors.azulAcao),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: AppText.corpo15.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                if (subtitulo != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitulo!,
                    style: AppText.corpo13.copyWith(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing ??
              const Icon(
                AppIcons.seta,
                size: 18,
                color: AppColors.textoSecundario,
              ),
        ],
      ),
    );
    return Semantics(
      button: aoTocar != null,
      label: [titulo, ?subtitulo, ?semanticaExtra].join(', '),
      excludeSemantics: true,
      onTap: aoTocar,
      child: aoTocar == null
          ? conteudo
          : InkWell(
              onTap: aoTocar,
              borderRadius: BorderRadius.circular(AppRadius.r16),
              child: conteudo,
            ),
    );
  }
}
