import 'package:flutter/material.dart';

import '../theme/motion.dart';

/// Faz o item de uma lista entrar (fade + 8 px de subida), cada um ~40 ms
/// depois do anterior. Só os primeiros `Motion.maxItensEscalonados` animam, e
/// só uma vez por abertura. Com "Reduzir animações", aparece direto.
class EntradaEscalonada extends StatefulWidget {
  const EntradaEscalonada({
    super.key,
    required this.indice,
    required this.child,
  });

  final int indice;
  final Widget child;

  @override
  State<EntradaEscalonada> createState() => _EntradaEscalonadaState();
}

class _EntradaEscalonadaState extends State<EntradaEscalonada>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progresso;
  bool _iniciou = false;

  bool get _anima => widget.indice < Motion.maxItensEscalonados;

  @override
  void initState() {
    super.initState();
    final atraso = Motion.intervaloEscalonado * widget.indice;
    final total = Motion.suave + atraso;
    _controller = AnimationController(vsync: this, duration: total);
    _progresso = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        atraso.inMilliseconds / total.inMilliseconds,
        1,
        curve: Motion.entrada,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciou) return;
    _iniciou = true;
    if (!_anima || Motion.reduzir(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progresso,
      child: RepaintBoundary(child: widget.child),
      builder: (context, child) {
        final v = _progresso.value;
        if (v >= 1) return child!;
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * Motion.deslocamento),
            child: child,
          ),
        );
      },
    );
  }
}
