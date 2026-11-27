import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// `AssetBundle` de teste que lê os arquivos de `assets/mock/` direto do
/// disco, de forma síncrona (E/S assíncrona real não anda dentro do `testWidgets`).
/// O `flutter test` roda na raiz do projeto. Assim os testes validam
/// os JSON de verdade, sem copiar dados.
class ArquivosBundle extends AssetBundle {
  ArquivosBundle({this.leituras});

  /// Conta quantas vezes cada arquivo foi lido (opcional).
  final Map<String, int>? leituras;

  @override
  Future<ByteData> load(String key) async {
    leituras?.update(key, (n) => n + 1, ifAbsent: () => 1);
    final arquivo = File(key);
    if (!arquivo.existsSync()) {
      throw FlutterError('Asset não encontrado: $key');
    }
    final bytes = utf8.encode(arquivo.readAsStringSync());
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}
