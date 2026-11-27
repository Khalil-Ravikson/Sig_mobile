import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_space.dart';
import '../../../core/theme/contraste_app.dart';
import '../../../core/theme/motion.dart';
import '../../../core/widgets/cabecalho_voltar.dart';
import '../../../core/widgets/conteudo_assincrono.dart';
import '../../../rotas.dart';
import 'aba_turma.dart';
import 'resumo_semestre_provider.dart';
import 'turma_virtual_view_model.dart';
import 'widgets/aba_em_breve.dart';
import 'widgets/aba_frequencia.dart';
import 'widgets/aba_notas.dart';
import 'widgets/aba_resumo.dart';
import 'widgets/chips_abas_turma.dart';
import 'widgets/esqueleto_turma.dart';

/// Turma virtual: cabeçalho com voltar, chips de áreas (a aba atual vive na
/// URL, em `?aba=`) e o conteúdo da área. Abre por cima das abas, sem barra.
class TurmaPage extends ConsumerWidget {
  const TurmaPage({super.key, required this.id, required this.aba});

  final String id;
  final AbaTurma aba;

  void _voltar(BuildContext context) {
    if (aba != AbaTurma.resumo) {
      context.go(Rotas.turma(id));
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go(Rotas.turmas);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(turmaVirtualViewModelProvider(id));
    final turma = estado.value;

    final rotuloVoltar = aba == AbaTurma.resumo
        ? 'Turmas'
        : (turma?.disciplina ?? 'Turma');
    final titulo = switch (aba) {
      AbaTurma.resumo => turma?.disciplina ?? 'Turma virtual',
      AbaTurma.frequencia => 'Mapa de frequência',
      _ => aba.rotulo,
    };
    final subtitulo = switch (aba) {
      AbaTurma.frequencia =>
        turma == null
            ? null
            : '${turma.semestre} · ${turma.totalAulas} aulas ministradas',
      _ => turma?.subtitulo,
    };

    return Scaffold(
      backgroundColor: context.fundoDaTela,
      body: Column(
        children: [
          CabecalhoVoltar(
            rotuloVoltar: rotuloVoltar,
            aoVoltar: () => _voltar(context),
            titulo: titulo,
            subtitulo: subtitulo,
            carregando: estado.isLoading && turma == null,
          ),
          ChipsAbasTurma(
            ativa: aba,
            aoSelecionar: (nova) {
              if (nova != aba) context.go(Rotas.turma(id, aba: nova.name));
            },
          ),
          Expanded(
            child: ConteudoAssincrono<TurmaVirtualUi>(
              valor: estado,
              esqueleto: const EsqueletoTurma(),
              aoTentarDeNovo: () {
                ref.invalidate(resumoSemestreProvider);
                ref.invalidate(turmaVirtualViewModelProvider(id));
              },
              erroPadding: const EdgeInsets.all(AppSpace.margemTela),
              dados: (turma) => _TrocaDeAba(
                aba: aba,
                child: switch (aba) {
                  AbaTurma.resumo => AbaResumo(
                    turma: turma,
                    aoVerMapa: () => context.go(
                      Rotas.turma(id, aba: AbaTurma.frequencia.name),
                    ),
                  ),
                  AbaTurma.frequencia => AbaFrequencia(turmaId: id),
                  AbaTurma.notas => AbaNotas(turma: turma),
                  AbaTurma.materiais ||
                  AbaTurma.atividades => AbaEmBreve(aba: aba),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Troca o conteúdo da área com fade + 8 px de deslocamento.
class _TrocaDeAba extends StatelessWidget {
  const _TrocaDeAba({required this.aba, required this.child});

  final AbaTurma aba;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Motion.duracao(context, Motion.padrao),
      switchInCurve: Motion.entrada,
      switchOutCurve: Motion.saida,
      transitionBuilder: (filho, animacao) => FadeTransition(
        opacity: animacao,
        child: AnimatedBuilder(
          animation: animacao,
          child: filho,
          builder: (context, filho) => Transform.translate(
            offset: Offset(0, (1 - animacao.value) * Motion.deslocamento),
            child: filho,
          ),
        ),
      ),
      layoutBuilder: (atual, anteriores) =>
          Stack(fit: StackFit.expand, children: [...anteriores, ?atual]),
      child: KeyedSubtree(key: ValueKey(aba), child: child),
    );
  }
}
