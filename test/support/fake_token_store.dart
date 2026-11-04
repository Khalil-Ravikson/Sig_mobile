import 'package:siguema_mobile/core/storage/token_store.dart';

/// TokenStore em memória, para testes (o cofre real precisa do aparelho).
class FakeTokenStore implements TokenStore {
  String? token;

  @override
  Future<String?> ler() async => token;

  @override
  Future<void> salvar(String novo) async => token = novo;

  @override
  Future<void> apagar() async => token = null;
}
