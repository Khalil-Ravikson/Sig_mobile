import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../../auth/presentation/sessao_provider.dart';
import '../domain/aluno.dart';
import '../domain/aluno_repository.dart';

part 'aluno_providers.g.dart';

/// Sem API ainda: quem usa o app precisa trocar por uma implementação
/// (o alpha faz isso em `main_alpha.dart`).
final alunoRepositoryProvider = Provider<AlunoRepository>(
  (ref) => throw UnimplementedError(
    'Sem implementação de AlunoRepository: use main_alpha.dart.',
  ),
);

/// O discente da sessão. Recarrega quando o vínculo muda.
@Riverpod(keepAlive: true)
Future<Aluno> aluno(Ref ref) async {
  ref.watch(sessaoProvider.select((s) => s.vinculo?.id));
  final resultado = await ref.watch(alunoRepositoryProvider).carregarAluno();
  return switch (resultado) {
    Sucesso(:final dado) => dado,
    Falha(:final erro) => throw erro,
  };
}
