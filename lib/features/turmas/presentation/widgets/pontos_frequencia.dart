import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Um ponto por aula (azul = presente, vermelho = falta), desenhados de uma
/// vez só: centenas de aulas não viram centenas de widgets.
class PontosFrequencia extends StatelessWidget {
  const PontosFrequencia({super.key, required this.pontos});

  /// Da aula mais antiga à mais nova: `true` = falta.
  final List<bool> pontos;

  static const diametro = 24.0;
  static const espaco = 10.0;

  @override
  Widget build(BuildContext context) {
    final faltas = pontos.where((p) => p).length;
    return Semantics(
      label: '${pontos.length} aulas, $faltas faltas',
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, restricoes) {
            final largura = restricoes.maxWidth;
            final colunas = ((largura + espaco) / (diametro + espaco))
                .floor()
                .clamp(1, 1000);
            final linhas = (pontos.length / colunas).ceil();
            final altura = linhas == 0
                ? 0.0
                : linhas * diametro + (linhas - 1) * espaco;
            return RepaintBoundary(
              child: CustomPaint(
                size: Size(largura, altura),
                painter: _PintorPontos(pontos, colunas),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PintorPontos extends CustomPainter {
  const _PintorPontos(this.pontos, this.colunas);

  final List<bool> pontos;
  final int colunas;

  @override
  void paint(Canvas canvas, Size size) {
    final presente = Paint()..color = AppColors.azulAcao;
    final falta = Paint()..color = AppColors.perigo;
    const raio = PontosFrequencia.diametro / 2;
    const passo = PontosFrequencia.diametro + PontosFrequencia.espaco;
    for (var i = 0; i < pontos.length; i++) {
      final centro = Offset(
        (i % colunas) * passo + raio,
        (i ~/ colunas) * passo + raio,
      );
      canvas.drawCircle(centro, raio, pontos[i] ? falta : presente);
    }
  }

  @override
  bool shouldRepaint(_PintorPontos antigo) =>
      antigo.colunas != colunas || !identical(antigo.pontos, pontos);
}
