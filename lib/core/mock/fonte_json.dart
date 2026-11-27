import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

/// Lê arquivos JSON de `assets/mock/` para os `Json*Repository` do alpha.
///
/// - Simula a espera da rede (400 a 900 ms) **só na primeira leitura**.
/// - Guarda o resultado em memória por [validade]; leituras seguintes dentro
///   do prazo voltam na hora.
/// - Leituras simultâneas do mesmo arquivo dividem uma única espera.
/// - Falhas não ficam no cache.
class FonteJson {
  FonteJson({
    required this.bundle,
    Duration Function()? latencia,
    DateTime Function()? agora,
    this.validade = const Duration(minutes: 5),
  }) : _latencia = latencia ?? _latenciaPadrao,
       _agora = agora ?? DateTime.now;

  final AssetBundle bundle;
  final Duration Function() _latencia;
  final DateTime Function() _agora;
  final Duration validade;

  final _cache = <String, _Entrada>{};

  static final _aleatorio = Random();

  static Duration _latenciaPadrao() =>
      Duration(milliseconds: 400 + _aleatorio.nextInt(501));

  /// Latência nula, para testes.
  static Duration semLatencia() => Duration.zero;

  /// Lê `assets/mock/<arquivo>` e devolve o JSON decodificado.
  Future<Object?> ler(String arquivo) {
    final entrada = _cache[arquivo];
    if (entrada != null && _agora().isBefore(entrada.venceEm)) {
      return entrada.dado;
    }
    final dado = _carregar(arquivo);
    final nova = _Entrada(dado, _agora().add(validade));
    _cache[arquivo] = nova;
    // Falha não fica guardada: a próxima leitura tenta de novo.
    dado.onError((Object _, StackTrace _) {
      if (identical(_cache[arquivo], nova)) _cache.remove(arquivo);
      return null;
    });
    return dado;
  }

  Future<Object?> _carregar(String arquivo) async {
    final espera = _latencia();
    if (espera > Duration.zero) await Future<void>.delayed(espera);
    final texto = await bundle.loadString('assets/mock/$arquivo');
    return jsonDecode(texto);
  }

  /// Esquece tudo o que estava guardado.
  void limpar() => _cache.clear();
}

class _Entrada {
  const _Entrada(this.dado, this.venceEm);

  final Future<Object?> dado;
  final DateTime venceEm;
}
