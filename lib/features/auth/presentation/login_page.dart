import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_error.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/cpf.dart';
import '../domain/resultado_login.dart';
import 'cpf_input_formatter.dart';
import 'login_view_model.dart';
import 'widgets/cabecalho_login.dart';
import 'widgets/campo_login.dart';
import 'widgets/cartao_ajuda.dart';

/// Tela de login por CPF e senha (Figma ACE-01, propostas A e C), com o
/// cabeçalho de borda curva. Com o teclado aberto o cabeçalho encolhe.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, required this.onEntrou});

  /// Chamado quando o login dá certo. A navegação fica a cargo de quem usa.
  final ValueChanged<ResultadoLogin> onEntrou;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _cpf = TextEditingController();
  final _senha = TextEditingController();
  bool _mostrarSenha = false;
  String? _erroCpf;
  String? _erroSenha;

  @override
  void dispose() {
    _cpf.dispose();
    _senha.dispose();
    super.dispose();
  }

  void _entrar() {
    setState(() {
      _erroCpf = cpfTemOnzeDigitos(_cpf.text)
          ? null
          : 'CPF inválido. Confira os 11 números.';
      _erroSenha = _senha.text.isEmpty ? 'Informe a senha.' : null;
    });
    if (_erroCpf != null || _erroSenha != null) return;

    FocusScope.of(context).unfocus();
    ref
        .read(loginViewModelProvider.notifier)
        .entrar(somenteDigitos(_cpf.text), _senha.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginViewModelProvider, (_, proximo) {
      if (proximo case AsyncData(:final value?)) widget.onEntrou(value);
    });

    final estado = ref.watch(loginViewModelProvider);
    final carregando = estado.isLoading;
    final erroApi = estado.hasError && estado.error is AppError
        ? estado.error! as AppError
        : null;
    final senhaRejeitada = erroApi is NaoAutorizado;
    final erroGeral = erroApi != null && !senhaRejeitada ? erroApi : null;
    final mostrarAjuda = erroApi != null || _erroCpf != null;
    final tecladoAberto = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CabecalhoLogin(compacto: tecladoAberto),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.marinho,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Use seu CPF e a senha do SIGUEMA',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CampoLogin(
                    rotulo: 'CPF',
                    controller: _cpf,
                    dica: '000.000.000-00',
                    erro: _erroCpf,
                    habilitado: !carregando,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.\-]')),
                      CpfInputFormatter(),
                    ],
                    onChanged: (_) => setState(() => _erroCpf = null),
                  ),
                  const SizedBox(height: 14),
                  CampoLogin(
                    rotulo: 'Senha',
                    controller: _senha,
                    dica: 'Sua senha',
                    erro:
                        _erroSenha ??
                        (senhaRejeitada ? erroApi.mensagem : null),
                    habilitado: !carregando,
                    obscuro: !_mostrarSenha,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    onChanged: (_) => setState(() => _erroSenha = null),
                    onSubmitted: (_) => _entrar(),
                    sufixo: TextButton(
                      onPressed: () =>
                          setState(() => _mostrarSenha = !_mostrarSenha),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(48, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.azulAcao,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(_mostrarSenha ? 'Ocultar' : 'Mostrar'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: carregando ? null : _entrar,
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
                      child: carregando
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Entrar'),
                    ),
                  ),
                  if (erroGeral != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      erroGeral.mensagem,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.erro,
                      ),
                    ),
                  ],
                  if (mostrarAjuda) ...[
                    const SizedBox(height: 14),
                    const CartaoAjuda(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
