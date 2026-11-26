import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';

class _BundleEmMemoria extends AssetBundle {
  _BundleEmMemoria(this.arquivos);

  final Map<String, String> arquivos;
  final leituras = <String, int>{};

  @override
  Future<ByteData> load(String key) async {
    leituras.update(key, (n) => n + 1, ifAbsent: () => 1);
    final texto = arquivos[key];
    if (texto == null) throw FlutterError('sem $key');
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(texto)));
  }
}

void main() {
  const arquivo = 'assets/mock/a.json';

  test('lê e decodifica o JSON', () async {
    final fonte = FonteJson(
      bundle: _BundleEmMemoria({arquivo: '{"x": 1}'}),
      latencia: FonteJson.semLatencia,
    );
    expect(await fonte.ler('a.json'), {'x': 1});
  });

  test('a primeira leitura espera a latência; a segunda volta na hora', () {
    fakeAsync((async) {
      final fonte = FonteJson(
        bundle: _BundleEmMemoria({arquivo: '{"x": 1}'}),
        latencia: () => const Duration(milliseconds: 600),
      );
      var primeira = false;
      var segunda = false;

      fonte.ler('a.json').then((_) => primeira = true);
      async.elapse(const Duration(milliseconds: 599));
      expect(primeira, isFalse);
      async.elapse(const Duration(milliseconds: 5));
      expect(primeira, isTrue);

      fonte.ler('a.json').then((_) => segunda = true);
      async.flushMicrotasks();
      expect(segunda, isTrue);
    });
  });

  test('leituras dentro da validade não releem o asset', () async {
    final bundle = _BundleEmMemoria({arquivo: '{}'});
    final fonte = FonteJson(bundle: bundle, latencia: FonteJson.semLatencia);
    await fonte.ler('a.json');
    await fonte.ler('a.json');
    expect(bundle.leituras[arquivo], 1);
  });

  test('depois da validade, lê de novo', () async {
    final bundle = _BundleEmMemoria({arquivo: '{}'});
    var agora = DateTime(2026, 11, 25, 8);
    final fonte = FonteJson(
      bundle: bundle,
      latencia: FonteJson.semLatencia,
      agora: () => agora,
      validade: const Duration(minutes: 5),
    );
    await fonte.ler('a.json');
    agora = agora.add(const Duration(minutes: 4));
    await fonte.ler('a.json');
    expect(bundle.leituras[arquivo], 1);
    agora = agora.add(const Duration(minutes: 2));
    await fonte.ler('a.json');
    expect(bundle.leituras[arquivo], 2);
  });

  test('leituras simultâneas dividem uma só leitura', () async {
    final bundle = _BundleEmMemoria({arquivo: '{}'});
    final fonte = FonteJson(bundle: bundle, latencia: FonteJson.semLatencia);
    await Future.wait([fonte.ler('a.json'), fonte.ler('a.json')]);
    expect(bundle.leituras[arquivo], 1);
  });

  test('falha não fica no cache', () async {
    final bundle = _BundleEmMemoria({});
    final fonte = FonteJson(bundle: bundle, latencia: FonteJson.semLatencia);
    await expectLater(fonte.ler('a.json'), throwsA(isA<FlutterError>()));
    bundle.arquivos[arquivo] = '{"ok": true}';
    expect(await fonte.ler('a.json'), {'ok': true});
  });
}
