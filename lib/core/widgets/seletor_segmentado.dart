import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../theme/contraste_app.dart';
import '../theme/motion.dart';

/// Seletor em pílulas (Pequeno · Médio · Grande): a opção ativa fica em azul
/// de ação, com troca animada de cor.
class SeletorSegmentado<T> extends StatelessWidget {
  const SeletorSegmentado({
    super.key,
    required this.opcoes,
    required this.valor,
    required this.aoMudar,
  });

  /// Valor → rótulo.
  final List<(T, String)> opcoes;
  final T valor;
  final ValueChanged<T> aoMudar;

  @override
  Widget build(BuildContext context) {
    final duracao = Motion.duracao(context, Motion.padrao);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.tonal(AppColors.fundoCampo),
        borderRadius: BorderRadius.circular(999),
        border: context.bordaContraste(),
      ),
      child: Row(
        children: [
          for (var i = 0; i < opcoes.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: Semantics(
                button: true,
                selected: opcoes[i].$1 == valor,
                label: opcoes[i].$2,
                excludeSemantics: true,
                onTap: () => aoMudar(opcoes[i].$1),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => aoMudar(opcoes[i].$1),
                  child: AnimatedContainer(
                    duration: duracao,
                    curve: Motion.entrada,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: opcoes[i].$1 == valor
                          ? AppColors.azulAcao
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: duracao,
                      curve: Motion.entrada,
                      style: AppText.corpo13.copyWith(
                        fontWeight: FontWeight.w600,
                        color: opcoes[i].$1 == valor
                            ? AppColors.branco
                            : AppColors.textoSecundario,
                      ),
                      child: Text(opcoes[i].$2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
