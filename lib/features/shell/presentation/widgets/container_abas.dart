import 'package:flutter/material.dart';

import '../../../../core/theme/motion.dart';

/// Mostra uma aba por vez, mantendo todas vivas (a rolagem de cada aba
/// continua onde parou). A troca anima fade + 8 px de deslocamento, como um
/// `AnimatedSwitcher` que não destrói o estado.
class ContainerAbas extends StatelessWidget {
  const ContainerAbas({super.key, required this.indice, required this.abas});

  final int indice;
  final List<Widget> abas;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < abas.length; i++)
          _AbaAnimada(ativa: i == indice, child: abas[i]),
      ],
    );
  }
}

class _AbaAnimada extends StatefulWidget {
  const _AbaAnimada({required this.ativa, required this.child});

  final bool ativa;
  final Widget child;

  @override
  State<_AbaAnimada> createState() => _AbaAnimadaState();
}

class _AbaAnimadaState extends State<_AbaAnimada>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: widget.ativa ? 1 : 0,
  );
  late final Animation<double> _curva = CurvedAnimation(
    parent: _controller,
    curve: Motion.trocaAba,
  );

  @override
  void didUpdateWidget(_AbaAnimada antigo) {
    super.didUpdateWidget(antigo);
    if (antigo.ativa == widget.ativa) return;
    _controller.animateTo(
      widget.ativa ? 1 : 0,
      duration: Motion.duracao(context, Motion.padrao),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curva,
      child: widget.child,
      builder: (context, child) {
        final v = _curva.value;
        return Offstage(
          offstage: v == 0 && !widget.ativa,
          child: TickerMode(
            enabled: widget.ativa,
            child: IgnorePointer(
              ignoring: !widget.ativa,
              child: ExcludeSemantics(
                excluding: !widget.ativa,
                child: Opacity(
                  opacity: v.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      Motion.reduzir(context)
                          ? 0
                          : (1 - v) * Motion.deslocamento,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
