import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/contraste_app.dart';
import '../../../../core/theme/motion.dart';
import '../aba_turma.dart';

/// Fileira rolável de chips da turma virtual. O chip ativo troca de cor com
/// animação e a fileira rola até ele.
class ChipsAbasTurma extends StatefulWidget {
  const ChipsAbasTurma({
    super.key,
    required this.ativa,
    required this.aoSelecionar,
  });

  final AbaTurma ativa;
  final ValueChanged<AbaTurma> aoSelecionar;

  @override
  State<ChipsAbasTurma> createState() => _ChipsAbasTurmaState();
}

class _ChipsAbasTurmaState extends State<ChipsAbasTurma> {
  final _chaves = {for (final aba in AbaTurma.values) aba: GlobalKey()};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _rolarAteAtiva(false));
  }

  @override
  void didUpdateWidget(ChipsAbasTurma antigo) {
    super.didUpdateWidget(antigo);
    if (antigo.ativa != widget.ativa) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _rolarAteAtiva(true));
    }
  }

  void _rolarAteAtiva(bool animar) {
    final contexto = _chaves[widget.ativa]?.currentContext;
    if (!mounted || contexto == null) return;
    Scrollable.ensureVisible(
      contexto,
      alignment: 0.5,
      duration: animar ? Motion.duracao(context, Motion.padrao) : Duration.zero,
      curve: Motion.entrada,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpace.margemTela,
        AppSpace.s16,
        AppSpace.margemTela,
        0,
      ),
      child: Row(
        children: [
          for (final aba in AbaTurma.values) ...[
            _Chip(
              key: _chaves[aba],
              aba: aba,
              ativa: aba == widget.ativa,
              aoTocar: () => widget.aoSelecionar(aba),
            ),
            if (aba != AbaTurma.values.last) const SizedBox(width: AppSpace.s8),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.aba,
    required this.ativa,
    required this.aoTocar,
  });

  final AbaTurma aba;
  final bool ativa;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final duracao = Motion.duracao(context, Motion.padrao);
    return Semantics(
      button: true,
      selected: ativa,
      label: aba.emBreve ? '${aba.rotulo}, em breve' : aba.rotulo,
      excludeSemantics: true,
      onTap: aoTocar,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: aoTocar,
        // Área de toque de 44; o chip em si tem 35, como no Figma.
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.5),
          child: AnimatedContainer(
            duration: duracao,
            curve: Motion.entrada,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: ativa
                  ? AppColors.azulAcao
                  : context.tonal(AppColors.fundoCampo),
              borderRadius: BorderRadius.circular(AppRadius.pilula),
              border: context.bordaContraste(),
            ),
            child: AnimatedDefaultTextStyle(
              duration: duracao,
              curve: Motion.entrada,
              style: AppText.corpo13.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: ativa ? AppColors.branco : AppColors.textoSecundario,
              ),
              child: Text(aba.rotulo),
            ),
          ),
        ),
      ),
    );
  }
}
