import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../auth/presentation/sessao_provider.dart';
import '../domain/resumo_semestre.dart';
import '../domain/semestre_repository.dart';

part 'resumo_semestre_provider.g.dart';

/// Sem API ainda: quem usa o app precisa trocar por uma implementação
/// (o alpha faz isso em `main_alpha.dart`).
final semestreRepositoryProvider = Provider<SemestreRepository>(
  (ref) => throw UnimplementedError(
    'Sem implementação de SemestreRepository: use main_alpha.dart.',
  ),
);

/// Um único carregamento alimenta Início e Turmas. Recarrega quando o vínculo
/// muda (outra pessoa, outro semestre), e só nesse caso.
@Riverpod(keepAlive: true)
Future<ResumoSemestre> resumoSemestre(Ref ref) async {
  ref.watch(sessaoProvider.select((s) => s.vinculo?.id));
  final resultado = await ref
      .watch(semestreRepositoryProvider)
      .carregarResumo();
  return switch (resultado) {
    Sucesso(:final dado) => dado,
    Falha(:final erro) => throw erro,
  };
}
