import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'brasao_uema.dart';

/// Cabeçalho marinho com borda curva e filete laranja (Flat 2.0).
/// Com o teclado aberto fica [compacto]: só o brasão e o nome.
class CabecalhoLogin extends StatelessWidget {
  const CabecalhoLogin({super.key, this.compacto = false});

  final bool compacto;

  static const alturaCheia = 210.0;
  static const alturaCompacta = 76.0;
  static const _filete = 4.0;

  @override
  Widget build(BuildContext context) {
    final topo = MediaQuery.paddingOf(context).top;
    final curva = compacto ? 16.0 : 26.0;
    final altura = (compacto ? alturaCompacta : alturaCheia) + topo;

    return SizedBox(
      height: altura,
      width: double.infinity,
      child: ClipPath(
        clipper: _BordaCurva(curva),
        child: ColoredBox(
          color: AppColors.laranja,
          child: Padding(
            padding: const EdgeInsets.only(bottom: _filete),
            child: ClipPath(
              clipper: _BordaCurva(curva),
              child: ColoredBox(
                color: AppColors.marinho,
                child: Stack(
                  children: [
                    const Positioned(
                      right: -44,
                      top: -34,
                      child: ExcludeSemantics(child: _Forma(tamanho: 190)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        topo + (compacto ? 14 : 24),
                        24,
                        0,
                      ),
                      child: compacto ? const _Compacto() : const _Cheio(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Cheio extends StatelessWidget {
  const _Cheio();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BrasaoUema(),
            SizedBox(width: 12),
            Text(
              'SIGUEMA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Text(
          'Sistema Integrado de Gestão de Atividades Acadêmicas · UEMA',
          style: TextStyle(fontSize: 12, color: AppColors.textoSobreMarinho),
        ),
      ],
    );
  }
}

class _Compacto extends StatelessWidget {
  const _Compacto();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        BrasaoUema(tamanho: 32),
        SizedBox(width: 10),
        Text(
          'SIGUEMA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _Forma extends StatelessWidget {
  const _Forma({required this.tamanho});

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.52,
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(
          color: AppColors.marinhoClaro,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

/// Retângulo com a base em meia-elipse: largura inteira, [curva] de altura.
class _BordaCurva extends CustomClipper<Path> {
  const _BordaCurva(this.curva);

  final double curva;

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - curva)
      ..arcToPoint(
        Offset(0, size.height - curva),
        radius: Radius.elliptical(size.width / 2, curva),
      )
      ..close();
  }

  @override
  bool shouldReclip(_BordaCurva antigo) => antigo.curva != curva;
}
