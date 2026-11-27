import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/perfil_local.dart';
import 'biometria_view_model.dart';
import 'widgets/cabecalho_login.dart';

/// Tela de quem já entrou neste aparelho: "Olá de novo" com a digital
/// (Figma ACE-01, proposta B). A navegação fica a cargo de quem usa.
class RetornoPage extends ConsumerWidget {
  const RetornoPage({
    super.key,
    required this.perfil,
    required this.onBiometriaOk,
    required this.onUsarSenha,
    required this.onOutroCpf,
  });

  final PerfilLocal perfil;

  /// A digital foi reconhecida.
  final VoidCallback onBiometriaOk;
  final VoidCallback onUsarSenha;
  final VoidCallback onOutroCpf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(biometriaViewModelProvider, (_, fase) {
      if (fase == FaseBiometria.sucesso) onBiometriaOk();
    });

    final fase = ref.watch(biometriaViewModelProvider);
    final autenticando = fase == FaseBiometria.autenticando;
    final deuErro =
        fase == FaseBiometria.naoReconhecida ||
        fase == FaseBiometria.bloqueada ||
        fase == FaseBiometria.indisponivel;
    final podeTentar =
        fase != FaseBiometria.bloqueada && fase != FaseBiometria.indisponivel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CabecalhoLogin(compacto: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: _Avatar(iniciais: perfil.iniciais, erro: deuErro),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _titulo(fase),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.marinho,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _subtitulo(fase, perfil),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: deuErro
                          ? AppColors.erro
                          : AppColors.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (podeTentar)
                    FilledButton.icon(
                      onPressed: autenticando
                          ? null
                          : () => ref
                                .read(biometriaViewModelProvider.notifier)
                                .autenticar(),
                      icon: autenticando
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.fingerprint, size: 22),
                      label: Text(
                        fase == FaseBiometria.naoReconhecida
                            ? 'Tentar de novo'
                            : 'Entrar com a digital',
                      ),
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
                    ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: autenticando ? null : onUsarSenha,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.azulAcao,
                      side: const BorderSide(
                        color: AppColors.azulAcao,
                        width: 1.5,
                      ),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Entrar com senha'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: autenticando ? null : onOutroCpf,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.azulAcao,
                      minimumSize: const Size.fromHeight(48),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Usar outro CPF'),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.fundoCampo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'A digital só vale neste aparelho.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textoSecundario,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _titulo(FaseBiometria fase) => switch (fase) {
    FaseBiometria.naoReconhecida => 'Não reconhecemos a digital',
    FaseBiometria.bloqueada => 'Digital bloqueada',
    FaseBiometria.indisponivel => 'Digital indisponível',
    _ => 'Olá de novo',
  };

  static String _subtitulo(FaseBiometria fase, PerfilLocal perfil) =>
      switch (fase) {
        FaseBiometria.naoReconhecida => 'Tente de novo ou use a senha.',
        FaseBiometria.bloqueada =>
          'O aparelho bloqueou a digital por um tempo. Use a senha.',
        FaseBiometria.indisponivel =>
          'Cadastre uma digital nas configurações do aparelho ou use a senha.',
        _ => 'CPF ${perfil.cpfMascarado}',
      };
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.iniciais, required this.erro});

  final String iniciais;
  final bool erro;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: erro ? AppColors.fundoCampoErro : AppColors.azulClaro,
        border: erro ? Border.all(color: AppColors.erro, width: 2) : null,
      ),
      child: erro
          ? const Icon(Icons.fingerprint, size: 38, color: AppColors.erro)
          : Text(
              iniciais,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.marinho,
              ),
            ),
    );
  }
}
