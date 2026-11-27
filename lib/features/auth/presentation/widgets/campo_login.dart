import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Campo de texto do login: preenchimento tonal, caixa de 12 px de raio, linha
/// azul no foco e vermelha no erro, com a mensagem abaixo.
class CampoLogin extends StatelessWidget {
  const CampoLogin({
    super.key,
    required this.rotulo,
    required this.controller,
    this.dica,
    this.erro,
    this.obscuro = false,
    this.sufixo,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.habilitado = true,
  });

  final String rotulo;
  final TextEditingController controller;
  final String? dica;
  final String? erro;
  final bool obscuro;
  final Widget? sufixo;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool habilitado;

  static OutlineInputBorder _borda(Color cor, double largura) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cor, width: largura),
      );

  @override
  Widget build(BuildContext context) {
    final temErro = erro != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textoSecundario,
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          label: rotulo,
          child: TextField(
            controller: controller,
            enabled: habilitado,
            obscureText: obscuro,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: const TextStyle(fontSize: 15, color: AppColors.marinho),
            decoration: InputDecoration(
              hintText: dica,
              hintStyle: const TextStyle(
                fontSize: 15,
                color: AppColors.textoSecundario,
              ),
              filled: true,
              fillColor: temErro
                  ? AppColors.fundoCampoErro
                  : AppColors.fundoCampo,
              contentPadding: const EdgeInsets.all(14),
              // `suffix` só aparece com o campo focado; `suffixIcon` sempre.
              suffixIcon: sufixo == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: sufixo,
                    ),
              suffixIconConstraints: const BoxConstraints(),
              enabledBorder: temErro
                  ? _borda(AppColors.erro, 2)
                  : _borda(Colors.transparent, 2),
              focusedBorder: temErro
                  ? _borda(AppColors.erro, 2)
                  : _borda(AppColors.azulAcao, 2),
              disabledBorder: _borda(Colors.transparent, 2),
            ),
          ),
        ),
        if (temErro) ...[
          const SizedBox(height: 6),
          Text(
            erro!,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.erro,
            ),
          ),
        ],
      ],
    );
  }
}
