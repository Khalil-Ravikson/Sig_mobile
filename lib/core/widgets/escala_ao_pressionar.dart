import 'package:flutter/widgets.dart';

import '../theme/motion.dart';

/// Reduz o filho a 0,97 enquanto o dedo está sobre ele e volta em 150 ms
/// (botões). Escuta o ponteiro por fora (`Listener`), sem disputar o toque
/// com o botão de dentro.
class EscalaAoPressionar extends StatefulWidget {
  const EscalaAoPressionar({super.key, required this.child});

  final Widget child;

  @override
  State<EscalaAoPressionar> createState() => _EscalaAoPressionarState();
}

class _EscalaAoPressionarState extends State<EscalaAoPressionar> {
  bool _pressionado = false;

  void _definir(bool valor) {
    if (_pressionado != valor) setState(() => _pressionado = valor);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _definir(true),
      onPointerUp: (_) => _definir(false),
      onPointerCancel: (_) => _definir(false),
      child: AnimatedScale(
        scale: _pressionado ? Motion.escalaPressionado : 1,
        duration: Motion.duracao(context, Motion.rapido),
        curve: Motion.entrada,
        child: widget.child,
      ),
    );
  }
}
