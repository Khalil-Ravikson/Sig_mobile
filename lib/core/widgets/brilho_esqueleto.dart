import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Brilho do esqueleto de carregamento, feito à mão (sem pacote). Envolva
/// vários [CaixaEsqueleto] com um só [BrilhoEsqueleto]: um controlador para
/// todos. Com "Reduzir animações", o esqueleto fica parado.
class BrilhoEsqueleto extends StatefulWidget {
  const BrilhoEsqueleto({super.key, required this.child});

  final Widget child;

  @override
  State<BrilhoEsqueleto> createState() => _BrilhoEsqueletoState();
}

class _BrilhoEsqueletoState extends State<BrilhoEsqueleto>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Carregando',
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            child: widget.child,
            builder: (context, child) {
              final t = _controller.value;
              return ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (area) => LinearGradient(
                  begin: Alignment(-1.5 + 3 * t, -0.3),
                  end: Alignment(-0.5 + 3 * t, 0.3),
                  colors: [
                    AppColors.azulClaro,
                    AppColors.branco.withValues(alpha: 0.9),
                    AppColors.azulClaro,
                  ],
                  stops: const [0.2, 0.5, 0.8],
                ).createShader(area),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Retângulo cinza-azulado do esqueleto. Use dentro de um [BrilhoEsqueleto].
class CaixaEsqueleto extends StatelessWidget {
  const CaixaEsqueleto({
    super.key,
    this.largura,
    required this.altura,
    this.raio = AppRadius.r12,
  });

  final double? largura;
  final double altura;
  final double raio;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: AppColors.azulClaro,
        borderRadius: BorderRadius.circular(raio),
      ),
    );
  }
}
