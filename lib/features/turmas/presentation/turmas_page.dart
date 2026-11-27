import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/aviso.dart';
import '../../../core/widgets/botao_sino.dart';
import '../../../core/widgets/cabecalho_app.dart';
import '../../../core/widgets/conteudo_assincrono.dart';
import '../../../core/widgets/entrada_escalonada.dart';
import '../../../rotas.dart';
import '../../shell/presentation/widgets/barra_bolha.dart';
import 'resumo_semestre_provider.dart';
import 'turmas_view_model.dart';
import 'widgets/cartao_turma.dart';
import 'widgets/esqueleto_turmas.dart';

/// Aba Turmas: lista de cartões do semestre.
class TurmasPage extends ConsumerWidget {
  const TurmasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(turmasViewModelProvider);
    final margemAviso = BarraBolha.alturaReservada(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: BarraBolha.alturaReservada(context)),
      child: Column(
        children: [
          CabecalhoApp(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpace.s8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Turmas',
                          style: AppText.titulo24.copyWith(
                            color: AppColors.branco,
                          ),
                        ),
                      ),
                      BotaoSino(
                        onTap: () => mostrarAviso(
                          context,
                          'Notificações chegam depois do alpha.',
                          margemInferior: margemAviso,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.s4),
                  _ChipSemestre(
                    semestre: estado.value?.semestre,
                    aoTocar: () => mostrarAviso(
                      context,
                      'No alpha, só o semestre atual.',
                      margemInferior: margemAviso,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.margemTela,
              AppSpace.s24,
              AppSpace.margemTela,
              0,
            ),
            child: ConteudoAssincrono<TurmasUi>(
              valor: estado,
              esqueleto: const EsqueletoTurmas(),
              aoTentarDeNovo: () => ref.invalidate(resumoSemestreProvider),
              ehVazio: (turmas) => turmas.turmas.isEmpty,
              vazio: const EstadoVazio(
                mensagem: 'Nenhuma turma neste semestre.',
              ),
              dados: (turmas) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turmas.turmas.length == 1
                        ? '1 turma'
                        : '${turmas.turmas.length} turmas',
                    style: AppText.subtitulo18,
                  ),
                  const SizedBox(height: AppSpace.s16),
                  for (var i = 0; i < turmas.turmas.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpace.s16),
                    EntradaEscalonada(
                      indice: i,
                      child: CartaoTurma(
                        turma: turmas.turmas[i],
                        aoTocar: () =>
                            context.push(Rotas.turma(turmas.turmas[i].id)),
                      ),
                    ),
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

class _ChipSemestre extends StatelessWidget {
  const _ChipSemestre({required this.semestre, required this.aoTocar});

  final String? semestre;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: AppColors.marinhoClaro,
        borderRadius: AppRadius.chip,
        child: InkWell(
          borderRadius: AppRadius.chip,
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  semestre == null ? 'Semestre' : 'Semestre $semestre',
                  style: AppText.legenda11.copyWith(color: AppColors.branco),
                ),
                const SizedBox(width: AppSpace.s4),
                const Icon(
                  AppIcons.expandir,
                  size: 14,
                  color: AppColors.branco,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
