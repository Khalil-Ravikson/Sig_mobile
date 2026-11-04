import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/domain/vinculo.dart';
import '../../auth/presentation/sessao_provider.dart';
import '../../auth/presentation/tipo_vinculo_texto.dart';
import '../data/turmas_exemplo.dart';
import 'widgets/cartao_turma.dart';
import 'widgets/hero_home.dart';
import 'widgets/menu_conta.dart';

/// Home: hero escuro (DISC-03 D) com o cartão de próxima aula sobreposto e a
/// lista de turmas (DISC-02 A). Turmas e próxima aula ainda são de exemplo.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessao = ref.watch(sessaoProvider);
    final vinculo = sessao.vinculo;
    if (vinculo == null) return const SizedBox.shrink();

    final notifier = ref.read(sessaoProvider.notifier);
    final nome = sessao.login?.nome ?? '';
    final topo = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            HeroHome(
              saudacao: 'Olá, ${nome.split(' ').first}',
              subtitulo: '${vinculo.tipo.titulo} · ${vinculo.descricao}',
              acao: MenuConta(
                iniciais: _iniciais(nome),
                podeTrocarVinculo: (sessao.login?.vinculos.length ?? 0) > 1,
                onTrocarVinculo: notifier.trocarVinculo,
                onSair: notifier.sair,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                topo + HeroHome.altura - 71,
                20,
                24,
              ),
              child: vinculo.tipo == TipoVinculo.aluno
                  ? const _ConteudoDiscente()
                  : const _EmBreve(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConteudoDiscente extends StatelessWidget {
  const _ConteudoDiscente();

  @override
  Widget build(BuildContext context) {
    final proxima = turmasExemplo[proximaAulaExemplo.turma];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CartaoTurma(
          turma: proxima,
          rotuloTitulo: 'Próxima: ',
          horario: proximaAulaExemplo.quando,
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Turmas',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.tinta,
              ),
            ),
            Text(
              '${turmasExemplo.length} no semestre',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textoSecundario,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (final turma in turmasExemplo) ...[
          CartaoTurma(turma: turma),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _EmBreve extends StatelessWidget {
  const _EmBreve();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borda),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'A Home deste vínculo chega em breve.',
        style: TextStyle(fontSize: 13, color: AppColors.textoSecundario),
      ),
    );
  }
}

String _iniciais(String nome) {
  final partes = nome.split(' ').where((p) => p.isNotEmpty).toList();
  if (partes.isEmpty) return '';
  if (partes.length == 1) return partes.first[0].toUpperCase();
  return (partes.first[0] + partes.last[0]).toUpperCase();
}
