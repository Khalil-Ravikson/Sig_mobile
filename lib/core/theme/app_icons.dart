import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Único ponto de acesso aos ícones do app (Lucide). Um papel, um ícone:
/// para trocar de ícone, mude só aqui. Tamanhos: 24 (abas), 22 (dentro do
/// quadrado tonal), 18 (botões e linhas).
abstract final class AppIcons {
  static const IconData inicio = LucideIcons.house;
  static const IconData turmas = LucideIcons.bookOpen;
  static const IconData documentos = LucideIcons.fileText;
  static const IconData perfil = LucideIcons.user;
  static const IconData meusDados = LucideIcons.idCard;
  static const IconData configuracoes = LucideIcons.slidersHorizontal;
  static const IconData ajuda = LucideIcons.circleQuestionMark;
  static const IconData trocarVinculo = LucideIcons.arrowLeftRight;
  static const IconData digital = LucideIcons.fingerprintPattern;
  static const IconData textoTamanho = LucideIcons.aLargeSmall;
  static const IconData contraste = LucideIcons.contrast;
  static const IconData privacidade = LucideIcons.shieldCheck;
  static const IconData sair = LucideIcons.logOut;
  static const IconData voltar = LucideIcons.chevronLeft;
  static const IconData seta = LucideIcons.chevronRight;
  static const IconData expandir = LucideIcons.chevronDown;
  static const IconData informacao = LucideIcons.info;
  static const IconData politica = LucideIcons.messageSquare;
  static const IconData externo = LucideIcons.arrowUpRight;
  static const IconData sino = LucideIcons.bell;
  static const IconData calendario = LucideIcons.calendar;
  static const IconData pdf = LucideIcons.fileDown;
  static const IconData sucesso = LucideIcons.check;
  static const IconData erro = LucideIcons.circleX;
  static const IconData materiais = LucideIcons.folder;
  static const IconData atividades = LucideIcons.clipboardCheck;
  static const IconData busca = LucideIcons.search;
  static const IconData email = LucideIcons.mail;
  static const IconData telefone = LucideIcons.phone;
  static const IconData vinculoDiscente = LucideIcons.graduationCap;
}
