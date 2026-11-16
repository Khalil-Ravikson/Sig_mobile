import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_error.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/resultado_login.dart';
import '../domain/vinculo.dart';
import 'escolha_vinculo_view_model.dart';
import 'widgets/cartao_vinculo.dart';

/// Escolha do vínculo depois do login (Figma ACE-02, proposta A).
/// Com um só vínculo, ele é escolhido sozinho e a lista nem aparece.
class VinculoPage extends ConsumerStatefulWidget {
  const VinculoPage({super.key, required this.resultado, required this.onSair});

  final ResultadoLogin resultado;

  /// Saída para quem não tem vínculo ou não consegue entrar.
  final VoidCallback onSair;

  @override
  ConsumerState<VinculoPage> createState() => _VinculoPageState();
}

class _VinculoPageState extends ConsumerState<VinculoPage> {
  static const _alturaHero = 250.0;

  bool get _unico => widget.resultado.vinculos.length == 1;

  @override
  void initState() {
    super.initState();
    if (_unico) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _escolher(widget.resultado.vinculos.single);
      });
    }
  }

  void _escolher(Vinculo vinculo) {
    ref.read(escolhaVinculoViewModelProvider.notifier).escolher(vinculo);
  }

  @override
  Widget build(BuildContext context) {
    final topo = MediaQuery.paddingOf(context).top;
    final resultado = widget.resultado;
    final primeiroNome = resultado.nome.split(' ').first;

    final estado = ref.watch(escolhaVinculoViewModelProvider);
    final erro = estado.hasError && estado.error is AppError
        ? estado.error! as AppError
        : null;
    // Com um só vínculo a escolha é automática: carregando até dar erro.
    final carregando = estado.isLoading || (_unico && erro == null);

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
                            Text(
                              resultado.vinculos.isEmpty
                                  ? 'Não encontramos um vínculo ativo no seu '
                                        'cadastro.'
                                  : 'Como você quer entrar hoje? Mostramos só '
                                        'o que seu cadastro permite.',
                              style: const TextStyle(
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
                  child: carregando
                      ? const _Entrando()
                      : resultado.vinculos.isEmpty
                      ? _SemVinculo(onSair: widget.onSair)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (erro != null) ...[
                              Text(
                                erro.mensagem,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.erro,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            for (final v in resultado.vinculos) ...[
                              CartaoVinculo(
                                vinculo: v,
                                onTap: () => _escolher(v),
                              ),
                              const SizedBox(height: 10),
                            ],
                            if (erro != null)
                              TextButton(
                                onPressed: widget.onSair,
                                child: const Text('Sair'),
                              ),
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

class _Entrando extends StatelessWidget {
  const _Entrando();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(height: 12),
            Text(
              'Entrando…',
              style: TextStyle(fontSize: 13, color: AppColors.textoSecundario),
            ),
          ],
        ),
      ),
    );
  }
}

class _SemVinculo extends StatelessWidget {
  const _SemVinculo({required this.onSair});

  final VoidCallback onSair;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nenhum vínculo ativo no seu cadastro. '
          'Procure a secretaria do seu curso.',
          style: TextStyle(fontSize: 13, color: AppColors.textoSecundario),
        ),
        TextButton(onPressed: onSair, child: const Text('Sair')),
      ],
    );
  }
}
