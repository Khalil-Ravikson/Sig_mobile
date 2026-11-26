import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_space.dart';
import 'cabecalho_fundo.dart';

/// Cabeçalho marinho das telas do app: altura 184, curva `radius/40` embaixo,
/// círculo decorativo e filete laranja de 3 px (Figma, componente Cabeçalho).
///
/// O [child] começa 48 px abaixo do topo (mais o que a barra de status
/// ocupar além de 24 px) e respeita a margem lateral de 24.
class CabecalhoApp extends StatelessWidget {
  const CabecalhoApp({
    super.key,
    required this.child,
    this.decorativo = true,
    this.conteudoNoFundo = false,
  });

  static const altura = 184.0;
  static const _origemConteudo = 48.0;
  static const _barraStatusDoFigma = 24.0;

  final Widget child;

  /// Mostra o círculo decorativo no canto (as telas de abas com sino usam).
  final bool decorativo;

  /// Encosta o [child] embaixo (24 px de margem), como em Documentos.
  final bool conteudoNoFundo;

  /// Altura total com a barra de status do aparelho.
  static double alturaTotal(BuildContext context) =>
      altura + _extraDoTopo(context);

  static double _extraDoTopo(BuildContext context) =>
      math.max(0, MediaQuery.paddingOf(context).top - _barraStatusDoFigma);

  @override
  Widget build(BuildContext context) {
    final extra = _extraDoTopo(context);
    return SizedBox(
      height: altura + extra,
      child: FundoCabecalho(
        decoracao: decorativo
            ? DecoracaoCabecalho.circulo
            : DecoracaoCabecalho.nenhuma,
        child: conteudoNoFundo
            ? Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.margemTela,
                  0,
                  AppSpace.margemTela,
                  AppSpace.s24,
                ),
                child: Align(alignment: Alignment.bottomLeft, child: child),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpace.margemTela,
                  _origemConteudo + extra,
                  AppSpace.margemTela,
                  0,
                ),
                child: child,
              ),
      ),
    );
  }
}
