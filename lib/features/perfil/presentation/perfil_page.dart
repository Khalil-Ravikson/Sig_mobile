import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/contraste_app.dart';
import '../../../core/util/iniciais.dart';
import '../../../core/widgets/brilho_esqueleto.dart';
import '../../../core/widgets/cartao_pressionavel.dart';
import '../../../core/widgets/conteudo_assincrono.dart';
import '../../../core/widgets/entrada_escalonada.dart';
import '../../../core/widgets/escala_ao_pressionar.dart';
import '../../../core/widgets/linha_menu.dart';
import '../../../rotas.dart';
import '../../aluno/presentation/aluno_providers.dart';
import '../../auth/presentation/sessao_provider.dart';
import 'perfil_view_model.dart';
import 'widgets/cabecalho_perfil.dart';

/// Perfil (identidade centralizada, Figma): resumo do curso, 4 atalhos e Sair.
/// Abre pela foto do topo, por cima das abas.
class PerfilPage extends ConsumerWidget {
  const PerfilPage({super.key});

  void _voltar(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Rotas.inicio);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nome = ref.watch(sessaoProvider.select((s) => s.login?.nome ?? ''));
    final estado = ref.watch(perfilViewModelProvider);

    return Scaffold(
      backgroundColor: context.fundoDaTela,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CabecalhoPerfil(
              nome: nome,
              iniciais: iniciaisDe(nome),
              perfil: estado.value,
              aoVoltar: () => _voltar(context),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpace.margemTela,
                AppSpace.s24,
                AppSpace.margemTela,
                AppSpace.s32 + MediaQuery.paddingOf(context).bottom,
              ),
              child: ConteudoAssincrono<PerfilUi>(
                valor: estado,
                esqueleto: const _EsqueletoPerfil(),
                aoTentarDeNovo: () => ref.invalidate(alunoProvider),
                dados: (perfil) => _Corpo(
                  perfil: perfil,
                  aoSair: () => ref.read(sessaoProvider.notifier).sair(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Corpo extends StatelessWidget {
  const _Corpo({required this.perfil, required this.aoSair});

  final PerfilUi perfil;
  final VoidCallback aoSair;

  @override
  Widget build(BuildContext context) {
    final itens = <Widget>[
      _CartaoResumo(perfil: perfil),
      Text(perfil.faltam, style: AppText.corpo13),
      CartaoLista(
        children: [
          LinhaMenu(
            icone: AppIcons.meusDados,
            titulo: 'Meus dados',
            subtitulo: 'E-mail, telefone e atualização',
            paddingVertical: 14,
            raioIcone: AppRadius.r16,
            aoTocar: () => context.push(Rotas.perfilDados),
          ),
          LinhaMenu(
            icone: AppIcons.documentos,
            titulo: 'Meus documentos',
            subtitulo: 'Comprovantes, histórico e calendário',
            paddingVertical: 14,
            raioIcone: AppRadius.r16,
            // `go` troca a pilha: o Perfil sai e a aba Documentos aparece.
            aoTocar: () => context.go(Rotas.documentos),
          ),
          LinhaMenu(
            icone: AppIcons.configuracoes,
            titulo: 'Configurações',
            subtitulo: 'Vínculo, digital e acessibilidade',
            paddingVertical: 14,
            raioIcone: AppRadius.r16,
            aoTocar: () => context.push(Rotas.perfilConfig),
          ),
          LinhaMenu(
            icone: AppIcons.ajuda,
            titulo: 'Ajuda',
            subtitulo: 'Perguntas e contatos',
            paddingVertical: 14,
            raioIcone: AppRadius.r16,
            aoTocar: () => context.push(Rotas.perfilAjuda),
          ),
        ],
      ),
      _BotaoSair(aoTocar: aoSair),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < itens.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpace.s16),
          EntradaEscalonada(indice: i, child: itens[i]),
        ],
      ],
    );
  }
}

class _CartaoResumo extends StatelessWidget {
  const _CartaoResumo({required this.perfil});

  final PerfilUi perfil;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _Numero(valor: perfil.cr, rotulo: 'CR'),
              ),
              const _Fio(),
              Expanded(
                child: _Numero(valor: perfil.periodo, rotulo: 'Período'),
              ),
              const _Fio(),
              Expanded(
                child: _Numero(
                  valor: perfil.integralizacao,
                  rotulo: 'Integralizado',
                  destaque: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Fio extends StatelessWidget {
  const _Fio();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 40,
    margin: const EdgeInsets.symmetric(vertical: 4),
    color: context.fio,
  );
}

class _Numero extends StatelessWidget {
  const _Numero({
    required this.valor,
    required this.rotulo,
    this.destaque = false,
  });

  final String valor;
  final String rotulo;
  final bool destaque;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$rotulo: $valor',
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              valor,
              style: AppText.titulo24.copyWith(
                fontSize: 22,
                height: 1.3,
                letterSpacing: 0,
                color: destaque ? AppColors.azulAcao : AppColors.marinho,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              rotulo,
              textAlign: TextAlign.center,
              style: AppText.corpo13.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotaoSair extends StatelessWidget {
  const _BotaoSair({required this.aoTocar});

  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Sair',
      excludeSemantics: true,
      onTap: aoTocar,
      child: EscalaAoPressionar(
        child: Material(
          color: context.tonal(AppColors.fundoCampoErro),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.ficha,
            side: context.altoContraste
                ? const BorderSide(color: AppColors.erro, width: 1.5)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: aoTocar,
            borderRadius: AppRadius.ficha,
            child: const SizedBox(
              width: double.infinity,
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AppIcons.sair, size: 18, color: AppColors.erro),
                  SizedBox(width: AppSpace.s8),
                  Text(
                    'Sair',
                    style: TextStyle(
                      fontFamily: AppText.familia,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.erro,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EsqueletoPerfil extends StatelessWidget {
  const _EsqueletoPerfil();

  @override
  Widget build(BuildContext context) {
    return const BrilhoEsqueleto(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CaixaEsqueleto(altura: 88, raio: AppRadius.r24),
          SizedBox(height: AppSpace.s16),
          CaixaEsqueleto(largura: 240, altura: 16),
          SizedBox(height: AppSpace.s16),
          CaixaEsqueleto(altura: 280, raio: AppRadius.r24),
        ],
      ),
    );
  }
}
