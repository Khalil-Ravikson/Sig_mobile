import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/widgets/avatar_perfil.dart';
import '../../../../core/widgets/brilho_esqueleto.dart';
import '../../../../core/widgets/cabecalho_fundo.dart';
import '../../../../core/widgets/selo_situacao.dart';
import '../perfil_view_model.dart';

/// Cabeçalho do Perfil (Figma): foto de 88, nome, vínculo e situação da
/// matrícula, centrados. A foto e o nome vêm da sessão (aparecem na hora, para
/// o `Hero` da foto já ter destino); o resto espera o carregamento.
class CabecalhoPerfil extends StatelessWidget {
  const CabecalhoPerfil({
    super.key,
    required this.nome,
    required this.iniciais,
    required this.perfil,
    required this.aoVoltar,
  });

  final String nome;
  final String iniciais;

  /// `null` enquanto carrega.
  final PerfilUi? perfil;
  final VoidCallback aoVoltar;

  @override
  Widget build(BuildContext context) {
    final extra = math.max(0.0, MediaQuery.paddingOf(context).top - 24);
    return FundoCabecalho(
      decoracao: DecoracaoCabecalho.quadradoInclinado,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpace.margemTela,
              64 + extra,
              AppSpace.margemTela,
              28,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  AvatarPerfil(iniciais: iniciais, tamanho: 88),
                  const SizedBox(height: 10),
                  Text(
                    nome,
                    textAlign: TextAlign.center,
                    style: AppText.titulo24.copyWith(
                      color: AppColors.branco,
                      fontSize: 22,
                      height: 1.25,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (perfil == null)
                    const BrilhoEsqueleto(
                      child: Column(
                        children: [
                          CaixaEsqueleto(largura: 200, altura: 16),
                          SizedBox(height: 10),
                          CaixaEsqueleto(largura: 120, altura: 22, raio: 999),
                        ],
                      ),
                    )
                  else ...[
                    Text(
                      perfil!.subtitulo,
                      textAlign: TextAlign.center,
                      style: AppText.corpo13.copyWith(
                        color: AppColors.textoSobreMarinho,
                      ),
                    ),
                    const SizedBox(height: 10),
                    perfil!.situacao.positiva
                        ? SeloSituacao.sucesso(perfil!.situacao.texto)
                        : SeloSituacao.aviso(perfil!.situacao.texto),
                  ],
                ],
              ),
            ),
          ),
          // Saída da tela: o Figma não desenha, mas sem ela o iOS não tem
          // como voltar (a transição própria não tem o gesto de arrastar).
          Positioned(
            left: 12,
            top: 8 + extra + MediaQuery.paddingOf(context).top.clamp(0, 24),
            child: Semantics(
              button: true,
              label: 'Voltar',
              excludeSemantics: true,
              child: IconButton(
                onPressed: aoVoltar,
                constraints: const BoxConstraints.tightFor(
                  width: 44,
                  height: 44,
                ),
                icon: const Icon(
                  AppIcons.voltar,
                  size: 22,
                  color: AppColors.textoSobreMarinho,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
