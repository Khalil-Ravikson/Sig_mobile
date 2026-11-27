import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fonte_json.dart';

/// Onde os assets são lidos. Testes trocam por um bundle falso.
final assetBundleProvider = Provider<AssetBundle>((ref) => rootBundle);

/// Espera simulada de cada primeira leitura. `null` = o padrão (400 a 900 ms).
/// Testes usam `FonteJson.semLatencia`.
final latenciaProvider = Provider<Duration Function()?>((ref) => null);

/// Relógio do app. No alpha é fixo (os JSON têm datas fixas); nos testes,
/// também, para os resultados não dependerem do dia em que rodam.
final relogioProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final fonteJsonProvider = Provider<FonteJson>(
  (ref) => FonteJson(
    bundle: ref.watch(assetBundleProvider),
    latencia: ref.watch(latenciaProvider),
  ),
);
