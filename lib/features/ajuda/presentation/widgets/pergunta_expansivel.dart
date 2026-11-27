import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/motion.dart';
import '../../domain/ajuda.dart';

/// Pergunta frequente: toca para abrir a resposta embaixo (a seta gira).
class PerguntaExpansivel extends StatefulWidget {
  const PerguntaExpansivel({super.key, required this.pergunta});

  final PerguntaFrequente pergunta;

  @override
  State<PerguntaExpansivel> createState() => _PerguntaExpansivelState();
}

class _PerguntaExpansivelState extends State<PerguntaExpansivel> {
  bool _aberta = false;

  @override
  Widget build(BuildContext context) {
    final duracao = Motion.duracao(context, Motion.padrao);
    return Semantics(
      button: true,
      expanded: _aberta,
      label: widget.pergunta.pergunta,
      excludeSemantics: true,
      onTap: () => setState(() => _aberta = !_aberta),
      child: InkWell(
        onTap: () => setState(() => _aberta = !_aberta),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.azulClaro,
                      borderRadius: BorderRadius.circular(AppRadius.r14),
                    ),
                    child: const Icon(
                      AppIcons.ajuda,
                      size: 22,
                      color: AppColors.azulAcao,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.pergunta.pergunta,
                      style: AppText.corpo15.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: _aberta ? 0.25 : 0,
                    duration: duracao,
                    curve: Motion.entrada,
                    child: const Icon(
                      AppIcons.seta,
                      size: 18,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: duracao,
                curve: Motion.entrada,
                alignment: Alignment.topCenter,
                child: _aberta
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(58, 10, 30, 2),
                        child: Text(
                          widget.pergunta.resposta,
                          style: AppText.corpo13,
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
