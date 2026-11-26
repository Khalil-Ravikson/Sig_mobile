import 'package:flutter/material.dart';

/// Cores tiradas do Figma (SIGUEMA Mobile — UI/UX Research) e da identidade
/// da UEMA. Marinho e laranja foram lidos do site da UEMA; trocar pelos
/// valores do manual de marca quando a UEMA enviar.
abstract final class AppColors {
  static const tinta = Color(0xFF262930);
  static const textoSecundario = Color(0xFF6B7080);
  static const textoSuave = Color(0xFFA8ADBA);
  static const borda = Color(0xFFD9DBE3);
  static const fundoHero = Color(0xFFF2F2F5);
  static const erro = Color(0xFFC73333);

  /// Azul-marinho da UEMA: cabeçalhos e barra inferior.
  static const marinho = Color(0xFF0F1E44);

  /// Tom mais claro do marinho, só para formas decorativas do cabeçalho.
  static const marinhoClaro = Color(0xFF16295F);

  /// Azul de ação: botões, links e foco dos campos (contraste alto no branco).
  static const azulAcao = Color(0xFF2C46C9);

  /// Laranja da UEMA: filetes, selos e destaques. Não usar como cor de texto
  /// sobre branco (contraste baixo).
  static const laranja = Color(0xFFFF7302);

  /// Preenchimento dos campos de texto e o mesmo campo em foco.
  static const fundoCampo = Color(0xFFF0F3FC);
  static const fundoCampoFoco = Color(0xFFE9EEFF);

  /// Fundo do erro nos campos.
  static const fundoCampoErro = Color(0xFFFCEEEE);

  /// Quadrado tonal atrás dos ícones.
  static const azulClaro = Color(0xFFE6EBFF);

  /// Texto de apoio sobre o marinho.
  static const textoSobreMarinho = Color(0xFFAEB9DD);

  /// Branco das superfícies (cartões, texto sobre marinho).
  static const branco = Color(0xFFFFFFFF);

  /// Fundo das telas do app (Flat 2.0): cartões brancos flutuam sobre ele.
  static const fundoTela = Color(0xFFF6F7FB);

  /// Situação positiva (Figma `status/success`, modo claro). Sempre com texto
  /// e ícone, nunca só a cor.
  static const sucesso = Color(0xFF167A43);

  /// Situação de atenção (Figma `status/warning`, modo claro).
  static const aviso = Color(0xFF8F6A00);

  /// Fundo do selo de sucesso (Figma `status/success-subtle`).
  static const sucessoFundo = Color(0xFFDDF3E6);

  /// Fundo do selo de atenção (Figma `status/warning-subtle`).
  static const avisoFundo = Color(0xFFFDF3C9);

  /// Situação negativa, como falta (Figma `status/danger`, modo claro).
  static const perigo = Color(0xFFC42128);

  /// Fundo do selo de perigo (Figma `status/danger-subtle`).
  static const perigoFundo = Color(0xFFFBE3E3);
}
