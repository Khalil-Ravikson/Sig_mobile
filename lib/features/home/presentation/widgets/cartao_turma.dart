import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/turma.dart';

/// Cartão de turma (Figma DISC-02 A). Com [destaque], vira o cartão de
/// "Próxima aula" do hero (DISC-03 D).
class CartaoTurma extends StatelessWidget {
  const CartaoTurma({
    super.key,
    required this.turma,
    this.rotuloTitulo,
    this.horario,
  });

  final Turma turma;

  /// Prefixo do título, como "Próxima: ".
  final String? rotuloTitulo;

  /// Substitui o horário da turma (ex.: o dia da próxima aula).
  final String? horario;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borda),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${rotuloTitulo ?? ''}${turma.disciplina}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tinta,
                  ),
                ),
              ),
              if (turma.novidades > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tinta,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    turma.novidades == 1
                        ? '1 nova'
                        : '${turma.novidades} novas',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 5),
          Text(
            horario ?? turma.horario,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.tinta,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            turma.curso,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textoSecundario,
            ),
          ),
        ],
      ),
    );
  }
}
