import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../domain/resultado_login.dart';
import 'auth_providers.dart';

part 'login_view_model.g.dart';

/// Estado: `null` (ainda não entrou), carregando, erro ou [ResultadoLogin].
@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  Future<ResultadoLogin?> build() async => null;

  Future<void> entrar(String cpf, String senha) async {
    state = const AsyncLoading();
    final resultado = await ref
        .read(authRepositoryProvider)
        .login(cpf: cpf, senha: senha);
    state = switch (resultado) {
      Sucesso(:final dado) => AsyncData(dado),
      Falha(:final erro) => AsyncError(erro, StackTrace.current),
    };
  }
}
