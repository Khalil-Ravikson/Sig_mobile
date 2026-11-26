import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/theme/contraste_app.dart';
import '../../../../core/widgets/anel_progresso.dart';
import '../../../../core/widgets/aviso.dart';
import '../../../../core/widgets/cartao_pressionavel.dart';
import '../../../../core/widgets/entrada_escalonada.dart';
import '../../../../core/widgets/numero_animado.dart';
import '../../../../core/widgets/selo_situacao.dart';
import '../turma_virtual_view_model.dart';
import 'celulas_notas.dart';

/// Aba Resumo: frequência como herói, notas, próxima avaliação e docente.
class AbaResumo extends StatelessWidget {
  const AbaResumo({super.key, required this.turma, required this.aoVerMapa});

  final TurmaVirtualUi turma;
  final VoidCallback aoVerMapa;

  @override
  Widget build(BuildContext context) {
    final proxima = turma.proxima;
    final itens = <Widget>[
      _CartaoFrequencia(turma: turma, aoVerMapa: aoVerMapa),
      const _Titulo('Notas'),
      CartaoCelulasNotas(celulas: turma.celulasDeNotas),
      const _Titulo('Próxima avaliação'),
      if (proxima != null)
        _CartaoProxima(proxima: proxima)
      else
        const _CartaoSemProxima(),
      _CartaoDocente(docente: turma.docente),
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpace.margemTela,
        AppSpace.s16,
        AppSpace.margemTela,
        AppSpace.s32 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < itens.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpace.s16),
            EntradaEscalonada(indice: i, child: itens[i]),
          ],
        ],
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  const _Titulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) =>
      Text(texto, style: AppText.corpo15.copyWith(fontWeight: FontWeight.w600));
}

class _CartaoFrequencia extends StatelessWidget {
  const _CartaoFrequencia({required this.turma, required this.aoVerMapa});

  final TurmaVirtualUi turma;
  final VoidCallback aoVerMapa;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        child: Row(
          children: [
            AnelProgresso(
              valor: turma.frequenciaPercentual / 100,
              tamanho: 112,
              rotuloSemantico: 'Frequência',
              child: NumeroAnimado(
                valor: turma.frequenciaPercentual.toDouble(),
                formatar: (v) => '${v.round()}%',
                estilo: AppText.titulo24.copyWith(
                  fontSize: 22,
                  height: 1.3,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(width: AppSpace.s20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequência',
                    style: AppText.corpo13.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpace.s8),
                  Text(
                    turma.textoFrequencia,
                    style: AppText.corpo15.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (turma.temAulas) ...[
                    const SizedBox(height: AppSpace.s8),
                    turma.dentroDoLimite
                        ? const SeloSituacao.sucesso('Dentro do limite')
                        : const SeloSituacao.perigo('Abaixo do mínimo'),
                  ],
                  const SizedBox(height: AppSpace.s4),
                  InkWell(
                    onTap: aoVerMapa,
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: AppSpace.alvoToque,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Ver mapa de frequência',
                              style: AppText.corpo13.copyWith(
                                color: AppColors.azulAcao,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(
                            AppIcons.seta,
                            size: 16,
                            color: AppColors.azulAcao,
                          ),
                        ],
                      ),
                    ),
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

class _CartaoProxima extends StatelessWidget {
  const _CartaoProxima({required this.proxima});

  final ProximaAvaliacaoUi proxima;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        semanticsLabel: '${proxima.titulo}, ${proxima.detalhe}',
        child: ExcludeSemantics(
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.tonal(AppColors.azulClaro),
                  borderRadius: AppRadius.ficha,
                  border: context.bordaContraste(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      proxima.dia,
                      style: AppText.subtitulo18.copyWith(
                        color: AppColors.azulAcao,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      proxima.mes,
                      style: AppText.legenda11.copyWith(
                        color: AppColors.azulAcao,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proxima.titulo,
                      style: AppText.corpo15.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(proxima.detalhe, style: AppText.corpo13),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartaoSemProxima extends StatelessWidget {
  const _CartaoSemProxima();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        child: Text(
          'Nenhuma avaliação marcada por enquanto.',
          style: AppText.corpo13,
        ),
      ),
    );
  }
}

class _CartaoDocente extends StatelessWidget {
  const _CartaoDocente({required this.docente});

  final DocenteUi docente;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CartaoPressionavel(
        padding: const EdgeInsets.all(AppSpace.s16),
        semanticsLabel: 'Docente ${docente.nome}, enviar e-mail',
        // O alpha não abre o app de e-mail: só mostra o endereço fictício.
        onTap: () =>
            mostrarAviso(context, 'E-mail do docente: ${docente.email}'),
        child: ExcludeSemantics(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.azulClaro,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  docente.iniciais,
                  style: AppText.corpo13.copyWith(
                    color: AppColors.azulAcao,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      docente.nome,
                      style: AppText.corpo15.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Docente · enviar e-mail',
                      style: AppText.corpo13,
                    ),
                  ],
                ),
              ),
              const Icon(
                AppIcons.seta,
                size: 20,
                color: AppColors.textoSecundario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
