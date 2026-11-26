import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_space.dart';
import '../../../../core/theme/app_text.dart';
import '../../../../core/widgets/cartao_pressionavel.dart';
import '../../../../core/widgets/entrada_escalonada.dart';
import '../turma_virtual_view_model.dart';
import 'celulas_notas.dart';

/// Aba Notas: o mesmo cartão do Resumo e, abaixo, a lista completa
/// (inclui 2ª chamada e prova final). O Figma ainda não desenhou esta aba.
class AbaNotas extends StatelessWidget {
  const AbaNotas({super.key, required this.turma});

  final TurmaVirtualUi turma;

  @override
  Widget build(BuildContext context) {
    final itens = <Widget>[
      CartaoCelulasNotas(celulas: turma.celulasDeNotas),
      Text(
        'Detalhes',
        style: AppText.corpo15.copyWith(fontWeight: FontWeight.w600),
      ),
      SizedBox(
        width: double.infinity,
        child: CartaoPressionavel(
          child: Column(
            children: [
              for (var i = 0; i < turma.detalhesDeNotas.length; i++) ...[
                if (i > 0) const SizedBox(height: 14),
                _Linha(
                  rotulo: turma.detalhesDeNotas[i].$1,
                  valor: turma.detalhesDeNotas[i].$2,
                ),
              ],
            ],
          ),
        ),
      ),
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

class _Linha extends StatelessWidget {
  const _Linha({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final lancada = valor != '—';
    return Semantics(
      label: lancada ? '$rotulo: $valor' : '$rotulo: ainda não lançada',
      child: ExcludeSemantics(
        child: Row(
          children: [
            Expanded(child: Text(rotulo, style: AppText.corpo15)),
            Text(
              valor,
              style: AppText.corpo15.copyWith(
                fontWeight: FontWeight.w600,
                color: lancada ? AppColors.marinho : AppColors.textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
