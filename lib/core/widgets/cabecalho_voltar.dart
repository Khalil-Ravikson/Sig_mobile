import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_space.dart';
import '../theme/app_text.dart';
import 'cabecalho_fundo.dart';

/// Cabeçalho marinho com voltar (Figma, "Cabeçalho · Com voltar"): link de
/// volta, título e uma linha de apoio. A altura acompanha o conteúdo. Com
/// [carregando], mostra barras no lugar dos textos.
///
/// Há duas medidas no Figma: a da turma virtual (título de 22) e a das telas
/// filhas do Perfil ([CabecalhoVoltar.filha]: título de 24, quadrado
/// decorativo no canto).
class CabecalhoVoltar extends StatelessWidget {
  const CabecalhoVoltar({
    super.key,
    required this.rotuloVoltar,
    required this.aoVoltar,
    required this.titulo,
    this.subtitulo,
    this.carregando = false,
  }) : tamanhoTitulo = 22,
       topo = 56,
       base = 24,
       decoracao = DecoracaoCabecalho.nenhuma;

  /// Telas filhas do Perfil (Meus dados, Configurações, Ajuda).
  const CabecalhoVoltar.filha({
    super.key,
    required this.rotuloVoltar,
    required this.aoVoltar,
    required this.titulo,
    this.subtitulo,
    this.carregando = false,
  }) : tamanhoTitulo = 24,
       topo = 64,
       base = 28,
       decoracao = DecoracaoCabecalho.quadradoInclinado;

  final String rotuloVoltar;
  final VoidCallback aoVoltar;
  final String titulo;
  final String? subtitulo;
  final bool carregando;
  final double tamanhoTitulo;
  final double topo;
  final double base;
  final DecoracaoCabecalho decoracao;

  /// Área de toque acima do texto de voltar (44 de altura no total).
  static const _areaDeToqueExtra = 13.0;

  @override
  Widget build(BuildContext context) {
    final extra = math.max(0.0, MediaQuery.paddingOf(context).top - 24);
    return FundoCabecalho(
      decoracao: decoracao,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpace.margemTela,
          topo - _areaDeToqueExtra + extra,
          AppSpace.margemTela,
          base - 5,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                button: true,
                label: 'Voltar para $rotuloVoltar',
                excludeSemantics: true,
                child: InkWell(
                  onTap: aoVoltar,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  child: SizedBox(
                    height: AppSpace.alvoToque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          AppIcons.voltar,
                          size: 16,
                          color: AppColors.textoSobreMarinho,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            rotuloVoltar,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.corpo13.copyWith(
                              color: AppColors.textoSobreMarinho,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (carregando) ...[
                const _Barra(largura: 220, altura: 26),
                const SizedBox(height: AppSpace.s12),
                const _Barra(largura: 160, altura: 14),
              ] else ...[
                Text(
                  titulo,
                  style: AppText.titulo24.copyWith(
                    color: AppColors.branco,
                    fontSize: tamanhoTitulo,
                    height: 1.25,
                    letterSpacing: 0,
                  ),
                ),
                if (subtitulo != null) ...[
                  const SizedBox(height: AppSpace.s8),
                  Text(
                    subtitulo!,
                    style: AppText.corpo13.copyWith(
                      color: AppColors.textoSobreMarinho,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Barra extends StatelessWidget {
  const _Barra({required this.largura, required this.altura});

  final double largura;
  final double altura;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: AppColors.marinhoClaro,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
    );
  }
}
