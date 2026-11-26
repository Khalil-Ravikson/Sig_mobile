import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/mock_providers.dart';
import '../../../core/util/formato_data.dart';
import '../../turmas/presentation/resumo_semestre_provider.dart';

part 'inicio_view_model.g.dart';

/// Prova ou atividade pronta para exibir.
class ProvaUi {
  const ProvaUi({
    required this.titulo,
    required this.dia,
    required this.mes,
    required this.quando,
  });

  final String titulo;
  final String dia;
  final String mes;
  final String quando;
}

class InicioUi {
  const InicioUi({
    required this.semestre,
    required this.cr,
    required this.integralizacao,
    required this.provas,
  });

  final String semestre;
  final double cr;

  /// 0 a 100.
  final int integralizacao;
  final List<ProvaUi> provas;
}

/// Quantas provas aparecem no Início.
const _maxProvas = 3;

/// Início: resumo do semestre e as próximas provas, do mesmo carregamento
/// que alimenta as Turmas.
@riverpod
Future<InicioUi> inicioViewModel(Ref ref) async {
  final resumo = await ref.watch(resumoSemestreProvider.future);
  final hoje = ref.watch(relogioProvider)();

  final futuras =
      resumo.proximasAvaliacoes
          .where((a) => FormatoData.diasAte(a.data, hoje) >= 0)
          .toList()
        ..sort((a, b) => a.data.compareTo(b.data));

  return InicioUi(
    semestre: resumo.semestre,
    cr: resumo.cr,
    integralizacao: resumo.integralizacaoPercentual,
    provas: [
      for (final a in futuras.take(_maxProvas))
        ProvaUi(
          titulo: a.titulo,
          dia: FormatoData.dia(a.data),
          mes: FormatoData.mesAbreviado(a.data),
          quando: FormatoData.emDias(a.data, hoje),
        ),
    ],
  );
}
