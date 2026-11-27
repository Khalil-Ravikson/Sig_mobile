import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Carrega a Public Sans em todos os testes. Sem isso o Flutter usa a fonte
/// "Ahem" (cada letra é um quadrado), e os textos ficam bem mais largos que
/// no aparelho, o que causa estouros de layout que não existem de verdade.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fonte = FontLoader('PublicSans');
  for (final peso in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    final bytes = File('assets/fonts/PublicSans-$peso.ttf').readAsBytesSync();
    fonte.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await fonte.load();
  await testMain();
}
