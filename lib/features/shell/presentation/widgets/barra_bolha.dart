import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/contraste_app.dart';
import '../../../../core/theme/motion.dart';

class ItemBarra {
  const ItemBarra({required this.icone, required this.rotulo});

  final IconData icone;
  final String rotulo;
}

/// Barra inferior flutuante com bolha (Figma, "Barra inferior (bolha)"):
/// solta das bordas, branca, cantos 28. A aba ativa sobe numa bolha azul e a
/// barra faz um recorte ao redor dela. A bolha desliza até a nova aba.
class BarraBolha extends StatelessWidget {
  const BarraBolha({
    super.key,
    required this.indice,
    required this.itens,
    required this.aoSelecionar,
  });

  /// Altura do conjunto (barra + bolha), sem a área segura do aparelho.
  static const altura = 120.0;
  static const _topoBarra = 28.0;
  static const _alturaBarra = 76.0;
  static const _diametroBolha = 56.0;
  static const _topoBolha = 8.0;

  final int indice;
  final List<ItemBarra> itens;
  final ValueChanged<int> aoSelecionar;

  /// Espaço que o conteúdo das abas deve deixar embaixo para a barra não
  /// cobri-lo.
  static double alturaReservada(BuildContext context) =>
      altura + MediaQuery.paddingOf(context).bottom / 2;

  @override
  Widget build(BuildContext context) {
    final contraste = context.altoContraste;
    final rodape = MediaQuery.paddingOf(context).bottom / 2;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpace.margemTela,
        right: AppSpace.margemTela,
        bottom: rodape,
      ),
      child: SizedBox(
        height: altura,
        child: LayoutBuilder(
          builder: (context, restricoes) {
            final larguraItem = restricoes.maxWidth / itens.length;
            return Material(
              type: MaterialType.transparency,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: indice.toDouble()),
                duration: Motion.duracao(context, Motion.padrao),
                curve: Motion.trocaAba,
                builder: (context, posicao, _) => Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: _topoBarra,
                      height: _alturaBarra,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _PintorBarra(
                            posicao: posicao,
                            quantidade: itens.length,
                            contraste: contraste,
                          ),
                        ),
                      ),
                    ),
                    for (var i = 0; i < itens.length; i++)
                      Positioned(
                        left: i * larguraItem,
                        width: larguraItem,
                        top: _topoBarra,
                        height: _alturaBarra,
                        child: _ItemDaBarra(
                          item: itens[i],
                          selecionado: i == indice,
                          distancia: (posicao - i).abs().clamp(0.0, 1.0),
                          aoTocar: () => aoSelecionar(i),
                        ),
                      ),
                    Positioned(
                      left: larguraItem * (posicao + 0.5) - _diametroBolha / 2,
                      top: _topoBolha,
                      child: IgnorePointer(
                        child: _Bolha(
                          icone: itens[indice].icone,
                          chave: indice,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemDaBarra extends StatelessWidget {
  const _ItemDaBarra({
    required this.item,
    required this.selecionado,
    required this.distancia,
    required this.aoTocar,
  });

  final ItemBarra item;
  final bool selecionado;

  /// 0 = a bolha está aqui; 1 = longe.
  final double distancia;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final cor = Color.lerp(
      AppColors.marinho,
      AppColors.textoSecundario,
      distancia,
    )!;
    return Semantics(
      button: true,
      selected: selecionado,
      label: item.rotulo,
      onTap: aoTocar,
      excludeSemantics: true,
      child: InkResponse(
        onTap: aoTocar,
        radius: 44,
        highlightShape: BoxShape.circle,
        child: Column(
          children: [
            const SizedBox(height: 14),
            Opacity(
              opacity: distancia,
              child: Icon(
                item.icone,
                size: 24,
                color: AppColors.textoSecundario,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.rotulo,
              maxLines: 1,
              style: AppText.legenda11.copyWith(
                color: cor,
                fontWeight: distancia < 0.5 ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bolha extends StatelessWidget {
  const _Bolha({required this.icone, required this.chave});

  final IconData icone;
  final int chave;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BarraBolha._diametroBolha,
      height: BarraBolha._diametroBolha,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.azulAcao,
        shape: BoxShape.circle,
        boxShadow: AppShadows.bolha,
      ),
      child: AnimatedSwitcher(
        duration: Motion.duracao(context, Motion.rapido),
        child: Icon(
          icone,
          key: ValueKey(chave),
          size: 24,
          color: AppColors.branco,
        ),
      ),
    );
  }
}

/// Fundo branco da barra, com sombra suave e o recorte redondo da bolha.
class _PintorBarra extends CustomPainter {
  const _PintorBarra({
    required this.posicao,
    required this.quantidade,
    required this.contraste,
  });

  final double posicao;
  final int quantidade;

  /// Alto contraste: sem sombra suave, com borda marinho.
  final bool contraste;

  @override
  void paint(Canvas canvas, Size size) {
    final corpo = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.r28),
        ),
      );
    final centroX = size.width / quantidade * (posicao + 0.5);
    final recorte = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(centroX, BarraBolha._topoBolha),
          radius: BarraBolha._diametroBolha / 2 + 6,
        ),
      );
    final forma = Path.combine(PathOperation.difference, corpo, recorte);

    if (contraste) {
      canvas.drawPath(forma, Paint()..color = AppColors.branco);
      canvas.drawPath(
        forma,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = AppColors.marinho,
      );
      return;
    }
    canvas.drawPath(
      forma.shift(const Offset(0, 4)),
      Paint()
        ..color = const Color(0x140F1E45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawPath(forma, Paint()..color = AppColors.branco);
  }

  @override
  bool shouldRepaint(_PintorBarra antigo) =>
      antigo.posicao != posicao ||
      antigo.quantidade != quantidade ||
      antigo.contraste != contraste;
}
