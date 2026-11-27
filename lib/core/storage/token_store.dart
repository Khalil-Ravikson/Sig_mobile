import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Guarda o token de acesso. Nunca guarda senha nem CPF.
abstract interface class TokenStore {
  Future<String?> ler();
  Future<void> salvar(String token);
  Future<void> apagar();
}

/// Usa o cofre do aparelho (Keychain no iOS, Keystore no Android).
class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _chave = 'access_token';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> ler() => _storage.read(key: _chave);

  @override
  Future<void> salvar(String token) =>
      _storage.write(key: _chave, value: token);

  @override
  Future<void> apagar() => _storage.delete(key: _chave);
}

final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());
