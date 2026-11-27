import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text.dart';
import '../theme/contraste_app.dart';

/// Selo de situação: ponto + texto. A situação nunca depende só da cor.
class SeloSituacao extends StatelessWidget {
  const SeloSituacao._({
    super.key,
    required this.texto,
    required this.cor,
    required this.fundo,
    Color? corTexto,
  }) : corTexto = corTexto ?? cor;

  /// Positivo (ex.: "Dentro do limite", "Presente").
  const SeloSituacao.sucesso(String texto, {Key? key})
    : this._(
        key: key,
        texto: texto,
        cor: AppColors.sucesso,
        fundo: AppColors.sucessoFundo,
      );

  /// Atenção, ainda não resolvido (ex.: "Sob pedido"). O texto fica em
  /// marinho; a cor de aviso é só do ponto (contraste do texto sobre o fundo).
  const SeloSituacao.aviso(String texto, {Key? key})
    : this._(
        key: key,
        texto: texto,
        cor: AppColors.aviso,
        fundo: AppColors.avisoFundo,
        corTexto: AppColors.marinho,
      );

  /// Negativo (ex.: "Abaixo do mínimo", "2 faltas").
  const SeloSituacao.perigo(String texto, {Key? key})
    : this._(
        key: key,
        texto: texto,
        cor: AppColors.perigo,
        fundo: AppColors.perigoFundo,
      );

  final String texto;
  final Color cor;
  final Color fundo;
  final Color corTexto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(AppRadius.pilula),
        border: context.bordaContraste(cor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            texto,
            style: AppText.corpo13.copyWith(
              color: corTexto,
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
