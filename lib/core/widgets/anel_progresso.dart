import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/contraste_app.dart';
import '../theme/motion.dart';

/// Anel de progresso: trilha azul clara e arco azul de ação. Anima de 0 até o
/// [valor] em `Motion.anel` (sem animar com "Reduzir animações").
class AnelProgresso extends StatelessWidget {
  const AnelProgresso({
    super.key,
    required this.valor,
    this.tamanho = 104,
    this.espessura = 12,
    this.child,
    this.rotuloSemantico,
  });

  /// De 0 a 1.
  final double valor;
  final double tamanho;
  final double espessura;

  /// Conteúdo no centro (por exemplo, o percentual).
  final Widget? child;
  final String? rotuloSemantico;

  @override
  Widget build(BuildContext context) {
    final alvo = valor.clamp(0.0, 1.0);
    // Em alto contraste a trilha precisa aparecer sobre o branco.
    final trilha = context.altoContraste
        ? AppColors.textoSuave
        : AppColors.azulClaro;
    return Semantics(
      label: rotuloSemantico,
      value: '${(alvo * 100).round()}%',
      child: RepaintBoundary(
        child: SizedBox(
          width: tamanho,
          height: tamanho,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: alvo),
            duration: Motion.duracao(context, Motion.anel),
            curve: Motion.entrada,
            builder: (context, atual, centro) => CustomPaint(
              painter: _PintorAnel(atual, espessura, trilha),
              child: Center(child: centro),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PintorAnel extends CustomPainter {
  const _PintorAnel(this.valor, this.espessura, this.corTrilha);

  final double valor;
  final double espessura;
  final Color corTrilha;

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    ).deflate(espessura / 2);
    final trilha = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = espessura
      ..color = corTrilha;
    canvas.drawArc(area, 0, 2 * math.pi, false, trilha);
    if (valor <= 0) return;
    final arco = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = espessura
      ..strokeCap = StrokeCap.round
      ..color = AppColors.azulAcao;
    canvas.drawArc(area, -math.pi / 2, 2 * math.pi * valor, false, arco);
  }

  @override
  bool shouldRepaint(_PintorAnel antigo) =>
      antigo.valor != valor ||
      antigo.espessura != espessura ||
      antigo.corTrilha != corTrilha;
}
