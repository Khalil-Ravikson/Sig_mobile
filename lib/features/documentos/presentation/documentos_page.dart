import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_space.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/aviso.dart';
import '../../../core/widgets/cabecalho_app.dart';
import '../../../core/widgets/campo_busca.dart';
import '../../../core/widgets/cartao_pressionavel.dart';
import '../../../core/widgets/conteudo_assincrono.dart';
import '../../../core/widgets/entrada_escalonada.dart';
import '../../shell/presentation/widgets/barra_bolha.dart';
import '../domain/documento.dart';
import 'documentos_view_model.dart';
import 'widgets/esqueleto_documentos.dart';
import 'widgets/linha_documento.dart';

/// Aba Documentos: comprovantes e declarações, com busca (300 ms depois da
/// última tecla).
class DocumentosPage extends ConsumerWidget {
  const DocumentosPage({super.key});

  void _tocou(BuildContext context, DocumentoUi documento) {
    // O alpha não gera PDF nem abre nada: só explica.
    final mensagem = documento.estado == EstadoDocumento.disponivel
        ? 'Alpha: o PDF "${documento.titulo}" não é gerado de verdade.'
        : 'Este documento é retirado na secretaria.';
    mostrarAviso(
      context,
      mensagem,
      margemInferior: BarraBolha.alturaReservada(context),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = ref.watch(documentosVisiveisProvider);
    final consulta = ref.read(consultaDocumentosProvider.notifier);

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(bottom: BarraBolha.alturaReservada(context)),
      child: Column(
        children: [
          CabecalhoApp(
            decorativo: false,
            conteudoNoFundo: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Documentos',
                  style: AppText.titulo24.copyWith(
                    color: AppColors.branco,
                    fontSize: 22,
                    height: 1.25,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Comprovantes e declarações em PDF',
                  style: AppText.corpo13.copyWith(
                    color: AppColors.textoSobreMarinho,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CampoBusca(
                  rotulo: 'Buscar documento',
                  aoMudar: consulta.digitar,
                  aoLimpar: consulta.limpar,
                ),
                const SizedBox(height: AppSpace.s24),
                ConteudoAssincrono<DocumentosUi>(
                  valor: estado,
                  esqueleto: const EsqueletoDocumentos(),
                  aoTentarDeNovo: () => ref.invalidate(documentosProvider),
                  ehVazio: (ui) => ui.semResultado,
                  vazio: EstadoVazio(
                    mensagem:
                        estado.hasValue &&
                            estado.requireValue.consulta.isNotEmpty
                        ? 'Nenhum documento encontrado para "${estado.requireValue.consulta}".'
                        : 'Nenhum documento disponível.',
                  ),
                  dados: (ui) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var g = 0; g < ui.grupos.length; g++) ...[
                        if (g > 0) const SizedBox(height: AppSpace.s24),
                        EntradaEscalonada(
                          indice: g,
                          child: _Grupo(
                            grupo: ui.grupos[g],
                            aoTocar: (d) => _tocou(context, d),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Grupo extends StatelessWidget {
  const _Grupo({required this.grupo, required this.aoTocar});

  final GrupoDocumentosUi grupo;
  final ValueChanged<DocumentoUi> aoTocar;

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
                for (var i = 0; i < grupo.itens.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpace.s16),
                  LinhaDocumento(
                    documento: grupo.itens[i],
                    aoTocar: () => aoTocar(grupo.itens[i]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
