import 'package:flutter/material.dart';

import '../theme/motion.dart';

/// Número que conta de 0 até [valor] em `Motion.anel` (junto com o anel).
class NumeroAnimado extends StatelessWidget {
  const NumeroAnimado({
    super.key,
    required this.valor,
    required this.formatar,
    required this.estilo,
  });

  final double valor;

  /// Transforma o valor corrente em texto (`87%`, `7,25`).
  final String Function(double valor) formatar;
  final TextStyle estilo;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: valor),
      duration: Motion.duracao(context, Motion.anel),
      curve: Motion.entrada,
      builder: (context, atual, _) => Text(
        formatar(atual),
        style: estilo.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
        semanticsLabel: formatar(valor),
      ),
    );
  }
}
