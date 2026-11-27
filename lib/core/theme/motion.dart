import 'package:flutter/widgets.dart';

/// Tokens de movimento. Regra: animar o que explica uma mudança, nunca
/// decorar o que é frequente. Nenhuma animação pode atrasar um toque.
abstract final class Motion {
  /// Toque e troca de ícone.
  static const rapido = Duration(milliseconds: 150);

  /// Estados, abas e selos.
  static const padrao = Duration(milliseconds: 250);

  /// Entrada de tela e listas.
  static const suave = Duration(milliseconds: 400);

  /// Anel de progresso e contagem de números.
  static const anel = Duration(milliseconds: 900);

  /// Atraso entre itens de uma lista que entra escalonada.
  static const intervaloEscalonado = Duration(milliseconds: 40);

  /// Máximo de itens que entram animados em uma lista.
  static const maxItensEscalonados = 8;

  static const Curve entrada = Curves.easeOutCubic;
  static const Curve saida = Curves.easeInCubic;
  static const Curve trocaAba = Curves.easeInOutCubicEmphasized;

  /// Deslocamento vertical das entradas, em pixels.
  static const double deslocamento = 8;

  /// Escala de cartões e botões ao pressionar.
  static const double escalaPressionado = 0.97;

  /// `true` quando o sistema ou a opção "Reduzir animações" pedem menos
  /// movimento (o app repassa a opção ao `MediaQuery.disableAnimations`).
  static bool reduzir(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// A duração a usar: zero quando o movimento deve ser reduzido.
  static Duration duracao(BuildContext context, Duration normal) =>
      reduzir(context) ? Duration.zero : normal;
}
