import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/theme/contraste_app.dart';
import 'widgets/barra_bolha.dart';

/// Moldura das 3 abas: o corpo (as abas) e a barra inferior flutuante.
/// Turma virtual e Perfil abrem por cima, sem a barra.
class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _itens = [
    ItemBarra(icone: AppIcons.inicio, rotulo: 'Início'),
    ItemBarra(icone: AppIcons.turmas, rotulo: 'Turmas'),
    ItemBarra(icone: AppIcons.documentos, rotulo: 'Documentos'),
  ];

  @override
  Widget build(BuildContext context) {
    final atual = navigationShell.currentIndex;
    return Scaffold(
      backgroundColor: context.fundoDaTela,
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Align(
            alignment: Alignment.bottomCenter,
            child: BarraBolha(
              indice: atual,
              itens: _itens,
              aoSelecionar: (i) =>
                  navigationShell.goBranch(i, initialLocation: i == atual),
            ),
          ),
        ],
      ),
    );
  }
}
