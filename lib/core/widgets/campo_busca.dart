import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_text.dart';
import '../theme/contraste_app.dart';
import '../theme/motion.dart';

/// Campo de busca no estilo dos campos do app (fundo `fundoCampo`, muda para
/// `fundoCampoFoco` em foco, sem borda dura). O botão de limpar aparece com
/// texto digitado.
class CampoBusca extends StatefulWidget {
  const CampoBusca({
    super.key,
    required this.rotulo,
    required this.aoMudar,
    this.aoLimpar,
  });

  /// Texto de dica e rótulo para leitores de tela.
  final String rotulo;
  final ValueChanged<String> aoMudar;
  final VoidCallback? aoLimpar;

  @override
  State<CampoBusca> createState() => _CampoBuscaState();
}

class _CampoBuscaState extends State<CampoBusca> {
  final _controller = TextEditingController();
  final _foco = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _foco.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _foco.dispose();
    super.dispose();
  }

  void _limpar() {
    _controller.clear();
    widget.aoLimpar?.call();
    widget.aoMudar('');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Motion.duracao(context, Motion.rapido),
      height: 48,
      decoration: BoxDecoration(
        color: context.tonal(
          _foco.hasFocus ? AppColors.fundoCampoFoco : AppColors.fundoCampo,
        ),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: context.bordaContraste(),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            AppIcons.busca,
            size: 18,
            color: AppColors.textoSecundario,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _foco,
              onChanged: widget.aoMudar,
              textInputAction: TextInputAction.search,
              style: AppText.corpo15,
              cursorColor: AppColors.azulAcao,
              decoration: InputDecoration(
                hintText: widget.rotulo,
                hintStyle: AppText.corpo15.copyWith(
                  color: AppColors.textoSecundario,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            Semantics(
              button: true,
              label: 'Limpar busca',
              excludeSemantics: true,
              child: InkResponse(
                onTap: _limpar,
                radius: 24,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    AppIcons.erro,
                    size: 18,
                    color: AppColors.textoSecundario,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 16),
        ],
      ),
    );
  }
}
