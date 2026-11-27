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
import '../../../core/widgets/campo_busca.dart';
import '../../../core/widgets/conteudo_assincrono.dart';
import '../../../core/widgets/entrada_escalonada.dart';
import '../../../core/widgets/escala_ao_pressionar.dart';
import '../../../core/widgets/linha_menu.dart';
import '../../../rotas.dart';
import '../domain/ajuda.dart';
import 'ajuda_view_model.dart';
import 'widgets/pergunta_expansivel.dart';

/// Ajuda: perguntas frequentes (com busca, 300 ms depois da última tecla) e
/// contatos da CTIC e da secretaria.
class AjudaPage extends ConsumerWidget {
  const AjudaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(ajudaVisivelProvider);
    final consulta = ref.read(consultaAjudaProvider.notifier);

    return Scaffold(
      backgroundColor: context.fundoDaTela,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            CabecalhoVoltar.filha(
              rotuloVoltar: 'Perfil',
              aoVoltar: () =>
                  context.canPop() ? context.pop() : context.go(Rotas.perfil),
              titulo: 'Ajuda',
              subtitulo: 'Perguntas e contatos',
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
                  CampoBusca(
                    rotulo: 'Buscar nas perguntas',
                    aoMudar: consulta.digitar,
                    aoLimpar: consulta.limpar,
                  ),
                  const SizedBox(height: AppSpace.s24),
                  ConteudoAssincrono<AjudaUi>(
                    valor: estado,
                    esqueleto: const BrilhoEsqueleto(
                      child: CaixaEsqueleto(altura: 360, raio: AppRadius.r24),
                    ),
                    aoTentarDeNovo: () => ref.invalidate(ajudaProvider),
                    dados: (ui) => _Corpo(ui: ui),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Corpo extends StatelessWidget {
  const _Corpo({required this.ui});

  final AjudaUi ui;

  @override
  Widget build(BuildContext context) {
    final blocos = <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perguntas frequentes',
            style: AppText.corpo15.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpace.s16),
          if (ui.semResultado)
            SizedBox(
              width: double.infinity,
              child: EstadoVazio(
                mensagem: 'Nenhuma pergunta encontrada para "${ui.consulta}".',
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: CartaoLista(
                children: [
                  for (final p in ui.perguntas)
                    PerguntaExpansivel(key: ValueKey(p.id), pergunta: p),
                ],
              ),
            ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Falar com alguém',
            style: AppText.corpo15.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpace.s16),
          SizedBox(
            width: double.infinity,
            child: CartaoLista(
              children: [
                for (final c in ui.contatos)
                  LinhaMenu(
                    icone: c.tipo == TipoContato.ctic
                        ? AppIcons.telefone
                        : AppIcons.email,
                    titulo: c.titulo,
                    subtitulo: c.descricao,
                    aoTocar: () => _mostrarContato(context, c),
                  ),
              ],
            ),
          ),
        ],
      ),
      _BotaoRelatar(
        aoTocar: () =>
            mostrarAviso(context, 'Alpha: o relato não é enviado a ninguém.'),
      ),
    ];
    return Column(
      children: [
        for (var i = 0; i < blocos.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpace.s16),
          EntradaEscalonada(indice: i, child: blocos[i]),
        ],
      ],
    );
  }
}

Future<void> _mostrarContato(BuildContext context, ContatoAjuda contato) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(contato.titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contato.descricao),
          const SizedBox(height: AppSpace.s12),
          Text('E-mail: ${contato.email}'),
          Text('Telefone: ${contato.telefone}'),
          Text('Atendimento: ${contato.horario}'),
          const SizedBox(height: AppSpace.s12),
          const Text('Contato fictício do alpha.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    ),
  );
}

class _BotaoRelatar extends StatelessWidget {
  const _BotaoRelatar({required this.aoTocar});

  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Relatar um problema',
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
              child: Center(
                child: Text(
                  'Relatar um problema',
                  style: AppText.corpo15.copyWith(
                    color: AppColors.branco,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
