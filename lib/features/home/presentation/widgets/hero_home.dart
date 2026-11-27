import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Hero escuro da Home (Figma DISC-03 D): saudação, subtítulo e a ação do
/// avatar (DISC-02 A) no canto.
class HeroHome extends StatelessWidget {
  const HeroHome({
    super.key,
    required this.saudacao,
    required this.subtitulo,
    required this.acao,
  });

  /// Altura do hero sem a barra de status.
  static const altura = 220.0;

  final String saudacao;
  final String subtitulo;
  final Widget acao;

  @override
  Widget build(BuildContext context) {
    final topo = MediaQuery.paddingOf(context).top;
    return ClipRect(
      child: Container(
        color: AppColors.tinta,
        width: double.infinity,
        height: altura + topo,
        child: Stack(
          children: [
            Positioned(
              right: -77,
              top: -80,
              child: ExcludeSemantics(
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
            ),
            Positioned(right: 20, top: topo + 12, child: acao),
            Padding(
              padding: EdgeInsets.fromLTRB(24, topo + 24, 72, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    saudacao,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.borda,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
