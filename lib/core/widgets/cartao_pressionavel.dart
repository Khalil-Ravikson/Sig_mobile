import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_space.dart';
import '../theme/contraste_app.dart';
import '../theme/motion.dart';

/// Cartão branco Flat 2.0 (cantos 24, sombra suave). Com [onTap], reduz a 0,97
/// ao pressionar e volta em 150 ms, com ripple discreto.
class CartaoPressionavel extends StatefulWidget {
  const CartaoPressionavel({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpace.paddingCartao),
    this.semanticsLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final String? semanticsLabel;

  @override
  State<CartaoPressionavel> createState() => _CartaoPressionavelState();
}

class _CartaoPressionavelState extends State<CartaoPressionavel> {
  bool _pressionado = false;

  @override
  Widget build(BuildContext context) {
    final conteudo = Padding(padding: widget.padding, child: widget.child);
    final interativo = widget.onTap != null;

    return AnimatedScale(
      scale: _pressionado ? Motion.escalaPressionado : 1,
      duration: Motion.duracao(context, Motion.rapido),
      curve: Motion.entrada,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.branco,
          borderRadius: AppRadius.cartao,
          boxShadow: context.sombraCartao,
          border: context.bordaContraste(),
        ),
        child: Semantics(
          button: interativo,
          label: widget.semanticsLabel,
          child: Material(
            type: MaterialType.transparency,
            child: interativo
                ? InkWell(
                    borderRadius: AppRadius.cartao,
                    onTap: widget.onTap,
                    onHighlightChanged: (valor) =>
                        setState(() => _pressionado = valor),
                    splashColor: AppColors.azulAcao.withValues(alpha: 0.08),
                    highlightColor: Colors.transparent,
                    child: conteudo,
                  )
                : conteudo,
          ),
        ),
      ),
    );
  }
}
