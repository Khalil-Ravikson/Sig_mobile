import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/resultado_login.dart';
import '../domain/vinculo.dart';
import 'widgets/cartao_vinculo.dart';

/// Escolha do vínculo depois do login (Figma ACE-02, proposta A).
/// Só aparece quando a pessoa tem mais de um vínculo.
class VinculoPage extends StatelessWidget {
  const VinculoPage({
    super.key,
    required this.resultado,
    required this.onEscolher,
  });

  final ResultadoLogin resultado;
  final ValueChanged<Vinculo> onEscolher;

  static const _alturaHero = 250.0;

  @override
  Widget build(BuildContext context) {
    final topo = MediaQuery.paddingOf(context).top;
    final primeiroNome = resultado.nome.split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.tinta,
      body: LayoutBuilder(
        builder: (context, restricoes) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ClipRect(
                  child: Container(
                    width: double.infinity,
                    height: _alturaHero + topo,
                    padding: EdgeInsets.fromLTRB(24, topo + 30, 24, 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: -57 - 24,
                          top: -60 - topo - 30,
                          child: ExcludeSemantics(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, $primeiroNome',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Como você quer entrar hoje? Mostramos só o que '
                              'seu cadastro permite.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.borda,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: restricoes.maxHeight - _alturaHero,
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: resultado.vinculos.isEmpty
                      ? const Text(
                          'Nenhum vínculo ativo no seu cadastro. '
                          'Procure a secretaria do seu curso.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textoSecundario,
                          ),
                        )
                      : Column(
                          children: [
                            for (final v in resultado.vinculos) ...[
                              CartaoVinculo(
                                vinculo: v,
                                onTap: () => onEscolher(v),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
