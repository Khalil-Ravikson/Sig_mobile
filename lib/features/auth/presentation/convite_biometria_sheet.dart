import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Folha de baixo: "Entrar com a digital da próxima vez?". Devolve `true` se
/// a pessoa quer ativar e `false` para "Agora não" (ou ao fechar a folha).
Future<bool> mostrarConviteBiometria(BuildContext context) async {
  final resposta = await showModalBottomSheet<bool>(
    context: context,
    // Sem isso a folha fica limitada a 9/16 da tela e o conteúdo estoura em
    // telas baixas ou com fonte grande.
    isScrollControlled: true,
    backgroundColor: Colors.white,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => const _ConviteBiometria(),
  );
  return resposta ?? false;
}

class _ConviteBiometria extends StatelessWidget {
  const _ConviteBiometria();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.azulClaro,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.fingerprint,
                size: 34,
                color: AppColors.azulAcao,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Entrar com a digital da próxima vez?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.marinho,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sua senha não fica guardada no aparelho. '
              'Você pode desligar depois.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textoSecundario),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.azulAcao,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Ativar a digital'),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.azulAcao,
                minimumSize: const Size.fromHeight(48),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Agora não'),
            ),
          ],
        ),
      ),
    );
  }
}
