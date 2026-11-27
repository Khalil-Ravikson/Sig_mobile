import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/util/formato_data.dart';
import '../../../../core/widgets/anel_progresso.dart';
import '../../../../core/widgets/cartao_pressionavel.dart';
import '../../../../core/widgets/conteudo_assincrono.dart';
import '../../../../core/widgets/entrada_escalonada.dart';
import '../../../../core/widgets/numero_animado.dart';
import '../../../../core/widgets/selo_situacao.dart';
import '../../domain/aula_dia.dart';
import '../../domain/frequencia_resumo.dart';
import '../frequencia_view_model.dart';
import 'esqueleto_turma.dart';
import 'pontos_frequencia.dart';

/// Mapa de frequência: limite de faltas, um ponto por aula e a lista por mês,
/// com rolagem infinita (20 dias por vez).
class AbaFrequencia extends ConsumerWidget {
  const AbaFrequencia({super.key, required this.turmaId});

  final String turmaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = frequenciaViewModelProvider(turmaId);
    return ConteudoAssincrono<FrequenciaUi>(
      valor: ref.watch(provider),
      esqueleto: const EsqueletoTurma(),
      aoTentarDeNovo: () => ref.invalidate(provider),
      ehVazio: (ui) => ui.resumo.totalAulas == 0,
      vazio: const EstadoVazio(mensagem: 'Ainda sem aulas registradas.'),
      dados: (ui) => _Mapa(ui: ui, turmaId: turmaId),
    );
  }
}

class _Mapa extends StatelessWidget {
  const _Mapa({required this.ui, required this.turmaId});

  final FrequenciaUi ui;
  final String turmaId;

  @override
  Widget build(BuildContext context) {
    final grupos = ui.grupos;
    final rodape = ui.temMais ? 1 : 0;
    final total = 2 + grupos.length + rodape;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSpace.margemTela,
            AppSpace.s16,
            AppSpace.margemTela,
            AppSpace.s32 + MediaQuery.paddingOf(context).bottom,
          ),
          sliver: SliverList.builder(
            itemCount: total,
            itemBuilder: (context, i) {
              final Widget item;
              if (i == 0) {
                item = EntradaEscalonada(
                  indice: 0,
                  child: _CartaoLimite(resumo: ui.resumo),
                );
              } else if (i == 1) {
                item = EntradaEscalonada(
                  indice: 1,
                  child: _CartaoPontos(pontos: ui.resumo.pontos),
                );
              } else if (i - 2 < grupos.length) {
                item = _GrupoDoMes(grupo: grupos[i - 2]);
              } else {
                item = _RodapeDaLista(
                  key: ValueKey('rodape-${ui.dias.length}'),
                  turmaId: turmaId,
                  ui: ui,
                );
              }
              return Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : AppSpace.s16),
                child: item,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CartaoLimite extends StatelessWidget {
  const _CartaoLimite({required this.resumo});

  final FrequenciaResumo resumo;

  @override
  Widget build(BuildContext context) {
    final percentual = resumo.percentual;
    final faltas = resumo.totalFaltas;
    final limite = resumo.limiteFaltas;
    final minimo = resumo.minimoPercentual;
    final dentro = resumo.dentroDoLimite;
    return SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        child: Row(
          children: [
            AnelProgresso(
              valor: percentual / 100,
              tamanho: 76,
              espessura: 8,
              rotuloSemantico: 'Frequência',
              child: NumeroAnimado(
                valor: percentual.toDouble(),
                formatar: (v) => '${v.round()}%',
                estilo: AppText.titulo24.copyWith(
                  fontSize: 16,
                  height: 1.3,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(width: AppSpace.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${faltas == 1 ? '1 falta' : '$faltas faltas'} · limite de $limite',
                    style: AppText.corpo15.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  dentro
                      ? const SeloSituacao.sucesso('Dentro do limite')
                      : const SeloSituacao.perigo('Acima do limite'),
                  const SizedBox(height: 6),
                  Text(
                    'Aprova com $minimo% ou mais de presença',
                    style: AppText.corpo13.copyWith(fontSize: 12),
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

class _CartaoPontos extends StatelessWidget {
  const _CartaoPontos({required this.pontos});

  final List<bool> pontos;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cada ponto é uma aula',
              style: AppText.corpo13.copyWith(
                color: AppColors.marinho,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            PontosFrequencia(pontos: pontos),
            const SizedBox(height: 14),
            const Row(
              children: [
                _Legenda(cor: AppColors.azulAcao, texto: 'Presente'),
                SizedBox(width: AppSpace.s16),
                _Legenda(cor: AppColors.perigo, texto: 'Falta'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legenda extends StatelessWidget {
  const _Legenda({required this.cor, required this.texto});

  final Color cor;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(texto, style: AppText.corpo13.copyWith(fontSize: 12)),
      ],
    );
  }
}

class _GrupoDoMes extends StatelessWidget {
  const _GrupoDoMes({required this.grupo});

  final GrupoMes grupo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          grupo.titulo,
          style: AppText.corpo15.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpace.s16),
        SizedBox(
          width: double.infinity,
          child: CartaoPressionavel(
            child: Column(
              children: [
                for (var i = 0; i < grupo.dias.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  _LinhaDoDia(dia: grupo.dias[i]),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LinhaDoDia extends StatelessWidget {
  const _LinhaDoDia({required this.dia});

  final AulaDia dia;

  @override
  Widget build(BuildContext context) {
    final data = FormatoData.diaMes(dia.data);
    final situacao = dia.teveFalta
        ? (dia.faltas == 1 ? '1 falta' : '${dia.faltas} faltas')
        : 'Presente';
    return Semantics(
      label: '$data, ${FormatoData.diaSemanaCurto(dia.data)}: $situacao',
      child: ExcludeSemantics(
        child: Row(
          children: [
            Text(
              data,
              style: AppText.corpo15.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: AppSpace.s12),
            Expanded(
              child: Text(
                FormatoData.diaSemanaCurto(dia.data),
                style: AppText.corpo13,
              ),
            ),
            dia.teveFalta
                ? SeloSituacao.perigo(situacao)
                : SeloSituacao.sucesso(situacao),
          ],
        ),
      ),
    );
  }
}

/// Fim da lista: pede a próxima página assim que aparece na tela (a lista é
/// lazy, então só é construído perto do fim) ou mostra o erro.
class _RodapeDaLista extends ConsumerStatefulWidget {
  const _RodapeDaLista({super.key, required this.turmaId, required this.ui});

  final String turmaId;
  final FrequenciaUi ui;

  @override
  ConsumerState<_RodapeDaLista> createState() => _RodapeDaListaState();
}

class _RodapeDaListaState extends ConsumerState<_RodapeDaLista> {
  @override
  void initState() {
    super.initState();
    if (!widget.ui.falhouAoCarregarMais) _pedir();
  }

  void _pedir() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(frequenciaViewModelProvider(widget.turmaId).notifier)
          .carregarMais();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ui.falhouAoCarregarMais) {
      return Column(
        children: [
          const Text(
            'Não foi possível carregar mais aulas.',
            style: AppText.corpo13,
          ),
          TextButton(onPressed: _pedir, child: const Text('Tentar de novo')),
        ],
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpace.s8),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }
}
