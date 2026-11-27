import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/biometria.dart';
import '../domain/perfil_local.dart';
import 'auth_providers.dart';

part 'convite_biometria_view_model.g.dart';

/// Regras do convite "Entrar com a digital da próxima vez?", feito depois do
/// primeiro login. A digital é sempre opcional.
@riverpod
class ConviteBiometriaViewModel extends _$ConviteBiometriaViewModel {
  @override
  FutureOr<void> build() {}

  /// Só convida se o aparelho tem biometria e a pessoa ainda não ativou nem
  /// disse "agora não".
  Future<bool> deveOferecer() async {
    final perfil = await ref.read(perfilLocalStoreProvider).ler();
    if (perfil != null && (perfil.biometriaAtiva || perfil.conviteRecusado)) {
      return false;
    }
    return ref.read(biometriaProvider).disponivel();
  }

  /// Confirma com a digital e só então liga. Devolve `true` se ligou.
  Future<bool> ativar(PerfilLocal perfil) async {
    final resultado = await ref
        .read(biometriaProvider)
        .autenticar(motivo: 'Confirme para entrar com a digital');
    if (resultado != ResultadoBiometria.sucesso) return false;
    await ref
        .read(perfilLocalStoreProvider)
        .salvar(perfil.copyWith(biometriaAtiva: true, conviteRecusado: false));
    return true;
  }

  Future<void> recusar(PerfilLocal perfil) => ref
      .read(perfilLocalStoreProvider)
      .salvar(perfil.copyWith(conviteRecusado: true));
}
