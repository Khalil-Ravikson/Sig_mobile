import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_error.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_space.dart';
import '../theme/app_text.dart';
import '../theme/motion.dart';

/// Troca com suavidade entre os quatro estados de uma tela: carregando
/// (esqueleto), dados, vazio e erro. Nada pula.
class ConteudoAssincrono<T> extends StatelessWidget {
  const ConteudoAssincrono({
    super.key,
    required this.valor,
    required this.dados,
    required this.esqueleto,
    this.ehVazio,
    this.vazio,
    this.aoTentarDeNovo,
    this.erroPadding = EdgeInsets.zero,
  });

  final AsyncValue<T> valor;
  final Widget Function(T dados) dados;
  final Widget esqueleto;

  /// Diz se os dados carregados contam como "vazio".
  final bool Function(T dados)? ehVazio;
  final Widget? vazio;
  final VoidCallback? aoTentarDeNovo;

  /// Margem em volta do estado de erro (telas que ocupam a tela toda).
  final EdgeInsetsGeometry erroPadding;

  @override
  Widget build(BuildContext context) {
    final Widget corpo;
    if (valor.hasValue) {
      final conteudo = valor.requireValue;
      if ((ehVazio?.call(conteudo) ?? false) && vazio != null) {
        corpo = KeyedSubtree(key: const ValueKey('vazio'), child: vazio!);
      } else {
        corpo = KeyedSubtree(
          key: const ValueKey('dados'),
          child: dados(conteudo),
        );
      }
    } else if (valor.hasError) {
      corpo = KeyedSubtree(
        key: const ValueKey('erro'),
        child: Padding(
          padding: erroPadding,
          child: EstadoErro(erro: valor.error, aoTentarDeNovo: aoTentarDeNovo),
        ),
      );
    } else {
      corpo = KeyedSubtree(key: const ValueKey('carregando'), child: esqueleto);
    }

    return AnimatedSwitcher(
      duration: Motion.duracao(context, Motion.padrao),
      switchInCurve: Motion.entrada,
      switchOutCurve: Motion.saida,
      layoutBuilder: (atual, anteriores) => Stack(
        alignment: Alignment.topCenter,
        children: [...anteriores, ?atual],
      ),
      child: corpo,
    );
  }
}

/// Estado de erro com botão para tentar de novo.
class EstadoErro extends StatelessWidget {
  const EstadoErro({super.key, required this.erro, this.aoTentarDeNovo});

  final Object? erro;
  final VoidCallback? aoTentarDeNovo;

  @override
  Widget build(BuildContext context) {
    final mensagem = erro is AppError
        ? (erro! as AppError).mensagem
        : 'Algo deu errado.';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.s32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(AppIcons.erro, size: 32, color: AppColors.erro),
          const SizedBox(height: AppSpace.s12),
          Text(
            'Não foi possível carregar',
            style: AppText.subtitulo18,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpace.s4),
          Text(mensagem, style: AppText.corpo13, textAlign: TextAlign.center),
          if (aoTentarDeNovo != null) ...[
            const SizedBox(height: AppSpace.s16),
            FilledButton.tonal(
              onPressed: aoTentarDeNovo,
              child: const Text('Tentar de novo'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mensagem simples para listas sem itens.
class EstadoVazio extends StatelessWidget {
  const EstadoVazio({super.key, required this.mensagem});

  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.s24),
      child: Center(
        child: Text(
          mensagem,
          style: AppText.corpo13,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
