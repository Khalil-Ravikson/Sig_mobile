import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../domain/vinculo.dart';
import 'auth_providers.dart';
import 'sessao_provider.dart';

part 'escolha_vinculo_view_model.g.dart';

/// Escolha do vínculo: troca o token temporário pelo definitivo e só então
/// marca o vínculo na sessão (o que abre a Home).
@riverpod
class EscolhaVinculoViewModel extends _$EscolhaVinculoViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> escolher(Vinculo vinculo) async {
    final login = ref.read(sessaoProvider).login;
    if (login == null) return;

    state = const AsyncLoading();
    final resultado = await ref
        .read(authRepositoryProvider)
        .escolherVinculo(
          vinculoId: vinculo.id,
          tokenTemporario: login.tokenTemporario,
        );
    if (!ref.mounted) return;

    switch (resultado) {
      case Sucesso():
        state = const AsyncData(null);
        ref.read(sessaoProvider.notifier).escolherVinculo(vinculo);
      case Falha(:final erro):
        state = AsyncError(erro, StackTrace.current);
    }
  }
}
