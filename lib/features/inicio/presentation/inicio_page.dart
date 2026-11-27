import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_space.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/util/formato_data.dart';
import '../../../core/util/iniciais.dart';
import '../../../core/widgets/avatar_perfil.dart';
import '../../../core/widgets/aviso.dart';
import '../../../core/widgets/botao_sino.dart';
import '../../../core/widgets/cabecalho_app.dart';
import '../../../core/widgets/conteudo_assincrono.dart';
import '../../../core/widgets/entrada_escalonada.dart';
import '../../../rotas.dart';
import '../../auth/presentation/sessao_provider.dart';
import '../../shell/presentation/widgets/barra_bolha.dart';
import '../../turmas/presentation/resumo_semestre_provider.dart';
import 'inicio_view_model.dart';
import 'widgets/cartao_resumo_semestre.dart';
import 'widgets/esqueleto_inicio.dart';
import 'widgets/grupo_provas.dart';

/// Aba Início: resumo do semestre (CR e integralização) e as próximas provas.
class InicioPage extends ConsumerWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nome = ref.watch(sessaoProvider.select((s) => s.login?.nome ?? ''));
    final estado = ref.watch(inicioViewModelProvider);
    final hoje = ref.watch(relogioProvider)();
    final semestre = estado.value?.semestre;
    final primeiroNome = nome.split(' ').first;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: BarraBolha.alturaReservada(context)),
      child: Column(
        children: [
          CabecalhoApp(
            child: Row(
              children: [
                AvatarPerfil(
                  iniciais: iniciaisDe(nome),
                  onTap: () => context.push(Rotas.perfil),
                ),
                const SizedBox(width: AppSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        primeiroNome.isEmpty ? 'Olá' : 'Olá, $primeiroNome',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titulo24.copyWith(
                          color: AppColors.branco,
                        ),
                      ),
                      Text(
                        [
                          FormatoData.diaSemanaDiaMes(hoje),
                          ?semestre,
                        ].join(' · '),
                        style: AppText.corpo13.copyWith(
                          color: AppColors.textoSobreMarinho,
                        ),
                      ),
                    ],
                  ),
                ),
                BotaoSino(
                  comPonto: true,
                  onTap: () => mostrarAviso(
                    context,
                    'Notificações chegam depois do alpha.',
                    margemInferior: BarraBolha.alturaReservada(context),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.margemTela,
              AppSpace.s24,
              AppSpace.margemTela,
              0,
            ),
            child: ConteudoAssincrono<InicioUi>(
              valor: estado,
              esqueleto: const EsqueletoInicio(),
              aoTentarDeNovo: () => ref.invalidate(resumoSemestreProvider),
              dados: (inicio) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EntradaEscalonada(
                    indice: 0,
                    child: CartaoResumoSemestre(
                      integralizacao: inicio.integralizacao,
                      cr: inicio.cr,
                    ),
                  ),
                  const SizedBox(height: AppSpace.s24),
                  EntradaEscalonada(
                    indice: 1,
                    child: GrupoProvas(
                      provas: inicio.provas,
                      aoVerTudo: () => mostrarAviso(
                        context,
                        'A lista completa chega depois do alpha.',
                        margemInferior: BarraBolha.alturaReservada(context),
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
}
