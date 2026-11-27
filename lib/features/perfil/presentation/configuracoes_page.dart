import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/versao_app.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/theme/contraste_app.dart';
import '../../../core/widgets/aviso.dart';
import '../../../core/widgets/cabecalho_voltar.dart';
import '../../../core/widgets/entrada_escalonada.dart';
import '../../../core/widgets/interruptor.dart';
import '../../../core/widgets/linha_menu.dart';
import '../../../core/widgets/seletor_segmentado.dart';
import '../../../rotas.dart';
import '../../auth/domain/vinculo.dart';
import '../../auth/presentation/sessao_provider.dart';
import '../domain/configuracoes.dart';
import 'configuracoes_provider.dart';

/// Configurações: conta, acessibilidade e privacidade. No alpha as
/// preferências ficam só em memória. "Reduzir animações" e "Tamanho do texto"
/// já valem no app todo; "Alto contraste" guarda a escolha (o efeito entra
/// no M5).
class ConfiguracoesPage extends ConsumerWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configuracoesProvider);
    final notifier = ref.read(configuracoesProvider.notifier);
    final sessao = ref.watch(sessaoProvider);
    final vinculos = sessao.login?.vinculos.length ?? 0;
    final vinculo = sessao.vinculo;

    final secoes = <Widget>[
      _Secao(
        titulo: 'Conta',
        child: CartaoLista(
          children: [
            if (vinculos > 1 && vinculo != null)
              LinhaMenu(
                icone: AppIcons.trocarVinculo,
                titulo: 'Trocar vínculo',
                subtitulo: _descricaoDoVinculo(vinculo),
                aoTocar: () =>
                    ref.read(sessaoProvider.notifier).trocarVinculo(),
              ),
            LinhaMenu(
              icone: AppIcons.digital,
              titulo: 'Entrar com a digital',
              subtitulo: config.digitalLigada
                  ? 'Ligada neste aparelho'
                  : 'Desligada',
              semanticaExtra: config.digitalLigada ? 'ligado' : 'desligado',
              trailing: Interruptor(ligado: config.digitalLigada),
              aoTocar: notifier.alternarDigital,
            ),
          ],
        ),
      ),
      _Secao(
        titulo: 'Acessibilidade',
        child: CartaoLista(
          children: [
            _TamanhoDoTexto(
              atual: config.tamanhoTexto,
              aoMudar: notifier.definirTamanhoTexto,
            ),
            LinhaMenu(
              icone: AppIcons.contraste,
              titulo: 'Alto contraste',
              semanticaExtra: config.altoContraste ? 'ligado' : 'desligado',
              trailing: Interruptor(ligado: config.altoContraste),
              aoTocar: notifier.alternarAltoContraste,
            ),
            LinhaMenu(
              icone: AppIcons.informacao,
              titulo: 'Reduzir animações',
              semanticaExtra: config.reduzirAnimacoes ? 'ligado' : 'desligado',
              trailing: Interruptor(ligado: config.reduzirAnimacoes),
              aoTocar: notifier.alternarReduzirAnimacoes,
            ),
          ],
        ),
      ),
      _Secao(
        titulo: 'Privacidade e app',
        child: CartaoLista(
          children: [
            LinhaMenu(
              icone: AppIcons.privacidade,
              titulo: 'Dados guardados no aparelho',
              subtitulo: 'CPF mascarado e iniciais',
              aoTocar: () => _mostrarDadosGuardados(context),
            ),
            LinhaMenu(
              icone: AppIcons.politica,
              titulo: 'Política de privacidade',
              subtitulo: 'Abre no navegador',
              trailing: const Icon(
                AppIcons.externo,
                size: 18,
                color: AppColors.textoSecundario,
              ),
              aoTocar: () => mostrarAviso(
                context,
                'Alpha: o endereço da política ainda não existe.',
              ),
            ),
            LinhaMenu(
              icone: AppIcons.informacao,
              titulo: 'Sobre o app',
              subtitulo: textoVersaoDoApp,
              aoTocar: () => mostrarAviso(
                context,
                'SIGUEMA Mobile, alpha com dados fictícios.',
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: context.fundoDaTela,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CabecalhoVoltar.filha(
              rotuloVoltar: 'Perfil',
              aoVoltar: () =>
                  context.canPop() ? context.pop() : context.go(Rotas.perfil),
              titulo: 'Configurações',
              subtitulo: 'Conta, acessibilidade e privacidade',
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpace.margemTela,
                AppSpace.s24,
                AppSpace.margemTela,
                AppSpace.s32 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < secoes.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpace.s16),
                    EntradaEscalonada(indice: i, child: secoes[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _descricaoDoVinculo(Vinculo vinculo) {
  final tipo = switch (vinculo.tipo) {
    TipoVinculo.aluno => 'Discente',
    TipoVinculo.professor => 'Docente',
    TipoVinculo.servidor => 'Servidor',
  };
  return '$tipo · ${vinculo.descricao}';
}

Future<void> _mostrarDadosGuardados(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Dados guardados no aparelho'),
      content: const Text(
        'Só guardamos o CPF mascarado (***.456.789-**), as suas iniciais e '
        'se a digital está ligada, em área protegida do aparelho. A sua '
        'senha nunca é guardada.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Entendi'),
        ),
      ],
    ),
  );
}

class _Secao extends StatelessWidget {
  const _Secao({required this.titulo, required this.child});

  final String titulo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: AppText.corpo15.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpace.s16),
        SizedBox(width: double.infinity, child: child),
      ],
    );
  }
}

class _TamanhoDoTexto extends StatelessWidget {
  const _TamanhoDoTexto({required this.atual, required this.aoMudar});

  final TamanhoTexto atual;
  final ValueChanged<TamanhoTexto> aoMudar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.azulClaro,
                  borderRadius: BorderRadius.circular(AppRadius.r14),
                ),
                child: const Icon(
                  AppIcons.textoTamanho,
                  size: 22,
                  color: AppColors.azulAcao,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Tamanho do texto',
                style: AppText.corpo15.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.s12),
          SeletorSegmentado<TamanhoTexto>(
            opcoes: [for (final t in TamanhoTexto.values) (t, t.rotulo)],
            valor: atual,
            aoMudar: aoMudar,
          ),
        ],
      ),
    );
  }
}
