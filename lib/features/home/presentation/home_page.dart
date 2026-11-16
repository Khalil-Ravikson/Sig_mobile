import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/sessao_provider.dart';
import '../../auth/presentation/tipo_vinculo_texto.dart';

/// Home provisória: mostra quem entrou e com qual vínculo. O conteúdo real
/// vem nas próximas tarefas.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessao = ref.watch(sessaoProvider);
    final vinculo = sessao.vinculo;
    if (vinculo == null) return const SizedBox.shrink();

    final primeiroNome = sessao.login?.nome.split(' ').first ?? '';
    final podeTrocar = (sessao.login?.vinculos.length ?? 0) > 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $primeiroNome',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.tinta,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                vinculo.tipo.titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.tinta,
                ),
              ),
              Text(
                vinculo.descricao,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textoSecundario,
                ),
              ),
              const SizedBox(height: 24),
              if (podeTrocar)
                TextButton(
                  onPressed: ref.read(sessaoProvider.notifier).trocarVinculo,
                  child: const Text('Trocar vínculo'),
                ),
              TextButton(
                onPressed: ref.read(sessaoProvider.notifier).sair,
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
