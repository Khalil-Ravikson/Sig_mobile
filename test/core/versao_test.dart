import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/config/versao_app.dart';

void main() {
  test('a versão mostrada em "Sobre o app" é a do pubspec', () {
    final linha = File(
      'pubspec.yaml',
    ).readAsLinesSync().firstWhere((l) => l.startsWith('version:'));
    final versao = linha.split(':').last.trim().split('+').first;
    expect(versao, versaoDoApp);
    expect(textoVersaoDoApp, 'Versão $versao (alpha)');
  });
}
