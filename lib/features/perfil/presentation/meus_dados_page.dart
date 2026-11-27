import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/contraste_app.dart';
import '../../../core/widgets/aviso.dart';
import '../../../core/widgets/brilho_esqueleto.dart';
import '../../../core/widgets/cabecalho_voltar.dart';
import '../../../core/widgets/conteudo_assincrono.dart';
import '../../../core/widgets/entrada_escalonada.dart';
import '../../../core/widgets/escala_ao_pressionar.dart';
import '../../../core/widgets/selo_situacao.dart';
import '../../../rotas.dart';
import '../../aluno/presentation/aluno_providers.dart';
import 'perfil_view_model.dart';

/// Meus dados: só leitura. Editar abre o portal (que pede a senha); no alpha
/// só mostra um aviso.
class MeusDadosPage extends ConsumerWidget {
  const MeusDadosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(meusDadosViewModelProvider);
    return Scaffold(
      backgroundColor: context.fundoDaTela,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CabecalhoVoltar.filha(
              rotuloVoltar: 'Perfil',
              aoVoltar: () =>
                  context.canPop() ? context.pop() : context.go(Rotas.perfil),
              titulo: 'Meus dados',
              subtitulo: 'Como estão no SIGUEMA',
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpace.margemTela,
                AppSpace.s24,
                AppSpace.margemTela,
                AppSpace.s32 + MediaQuery.paddingOf(context).bottom,
              ),
              child: ConteudoAssincrono<MeusDadosUi>(
                valor: estado,
                esqueleto: const BrilhoEsqueleto(
                  child: CaixaEsqueleto(altura: 380, raio: AppRadius.r24),
                ),
                aoTentarDeNovo: () => ref.invalidate(alunoProvider),
                dados: (dados) => _Corpo(dados: dados),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Corpo extends StatelessWidget {
  const _Corpo({required this.dados});

  final MeusDadosUi dados;

  @override
  Widget build(BuildContext context) {
    final itens = <Widget>[
      _CartaoDados(dados: dados),
      const _AvisoEdicao(),
      _BotaoPortal(
        aoTocar: () => mostrarAviso(
          context,
          'Alpha: o portal abriria no navegador, pedindo sua senha.',
        ),
      ),
    ];
    return Column(
      children: [
        for (var i = 0; i < itens.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpace.s16),
          EntradaEscalonada(indice: i, child: itens[i]),
        ],
      ],
    );
  }
}

class _CartaoDados extends StatelessWidget {
  const _CartaoDados({required this.dados});

  final MeusDadosUi dados;

  @override
  Widget build(BuildContext context) {
    final linhas = <Widget>[
      _Linha(rotulo: 'Matrícula', valor: dados.matricula),
      _Linha(rotulo: 'Curso', valor: dados.curso),
      _Linha(rotulo: 'Nível', valor: dados.nivel),
      _LinhaSelo(rotulo: 'Status', situacao: dados.situacao),
      _Linha(rotulo: 'Entrada', valor: dados.entrada),
      _Linha(rotulo: 'E-mail', valor: dados.email),
      _Linha(rotulo: 'Telefone', valor: dados.telefone),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: AppRadius.cartao,
        boxShadow: context.sombraCartao,
        border: context.bordaContraste(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.paddingCartao),
        child: Column(
          children: [
            for (var i = 0; i < linhas.length; i++) ...[
              if (i > 0) ...[
                const SizedBox(height: 14),
                Divider(height: 1, thickness: 1, color: context.fio),
                const SizedBox(height: 14),
              ],
              linhas[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _Linha extends StatelessWidget {
  const _Linha({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$rotulo: $valor',
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rotulo, style: AppText.corpo13),
            const SizedBox(width: AppSpace.s16),
            Expanded(
              child: Text(
                valor,
                textAlign: TextAlign.right,
                style: AppText.corpo13.copyWith(
                  color: AppColors.marinho,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinhaSelo extends StatelessWidget {
  const _LinhaSelo({required this.rotulo, required this.situacao});

  final String rotulo;
  final SituacaoUi situacao;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$rotulo: ${situacao.texto}',
      child: ExcludeSemantics(
        child: Row(
          children: [
            Expanded(child: Text(rotulo, style: AppText.corpo13)),
            situacao.positiva
                ? SeloSituacao.sucesso(situacao.texto)
                : SeloSituacao.aviso(situacao.texto),
          ],
        ),
      ),
    );
  }
}

class _AvisoEdicao extends StatelessWidget {
  const _AvisoEdicao();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: BoxDecoration(
        color: context.tonal(AppColors.azulClaro),
        borderRadius: AppRadius.cartao,
        border: context.bordaContraste(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quer corrigir algum dado?',
            style: AppText.corpo13.copyWith(
              color: AppColors.marinho,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpace.s8),
          Text(
            'A edição pede sua senha e acontece no portal. Dados bancários e '
            'socioeconômicos ficam só lá.',
            style: AppText.corpo13.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _BotaoPortal extends StatelessWidget {
  const _BotaoPortal({required this.aoTocar});

  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Atualizar no portal',
      excludeSemantics: true,
      onTap: aoTocar,
      child: EscalaAoPressionar(
        child: Material(
          color: AppColors.azulAcao,
          borderRadius: AppRadius.ficha,
          child: InkWell(
            onTap: aoTocar,
            borderRadius: AppRadius.ficha,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Atualizar no portal',
                    style: AppText.corpo15.copyWith(
                      color: AppColors.branco,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpace.s8),
                  const Icon(
                    AppIcons.externo,
                    size: 18,
                    color: AppColors.branco,
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
