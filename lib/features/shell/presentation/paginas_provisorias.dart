import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_space.dart';
import '../../../core/theme/app_text.dart';
import '../../auth/presentation/sessao_provider.dart';

// Telas provisórias: cada uma é trocada pela tela real no marco indicado.

/// Para vínculos que não são de discente (docente e servidor ficam para uma
/// atualização futura).
class VinculoEmBreveProvisorioPage extends ConsumerWidget {
  const VinculoEmBreveProvisorioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessao = ref.watch(sessaoProvider);
    final notifier = ref.read(sessaoProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.fundoTela,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.margemTela),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'A área deste vínculo chega em breve.',
                style: AppText.subtitulo18,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpace.s8),
              const Text(
                'O alpha mostra só o portal do discente.',
                style: AppText.corpo13,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpace.s24),
              if ((sessao.login?.vinculos.length ?? 0) > 1)
                TextButton(
                  onPressed: notifier.trocarVinculo,
                  child: const Text('Trocar vínculo'),
                ),
              TextButton(onPressed: notifier.sair, child: const Text('Sair')),
            ],
          ),
        ),
      ),
    );
  }
}
