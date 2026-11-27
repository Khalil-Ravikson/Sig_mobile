import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/perfil_local.dart';

/// Guarda o [PerfilLocal] no cofre do aparelho, como JSON.
class PerfilLocalStoreSeguro implements PerfilLocalStore {
  PerfilLocalStoreSeguro([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _chave = 'perfil_local';

  final FlutterSecureStorage _storage;

  @override
  Future<PerfilLocal?> ler() async {
    try {
      final texto = await _storage.read(key: _chave);
      if (texto == null) return null;
      return PerfilLocal.fromJson(jsonDecode(texto) as Map<String, Object?>);
    } on Object {
      // Dado corrompido ou cofre indisponível: tratar como "sem perfil".
      return null;
    }
  }

  @override
  Future<void> salvar(PerfilLocal perfil) =>
      _storage.write(key: _chave, value: jsonEncode(perfil.toJson()));

  @override
  Future<void> apagar() => _storage.delete(key: _chave);
}
