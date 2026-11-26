// ignore: depend_on_referenced_packages
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/util/debouncer.dart';
import 'package:siguema_mobile/core/util/texto.dart';

void main() {
  group('normalizarParaBusca', () {
    test('minúsculo, sem acento e sem espaços nas pontas', () {
      expect(
        normalizarParaBusca('  Declaração de Vínculo '),
        'declaracao de vinculo',
      );
      expect(normalizarParaBusca('Matrícula'), 'matricula');
      expect(normalizarParaBusca('AÇÃO'), 'acao');
      expect(normalizarParaBusca(''), '');
    });
  });

  group('Debouncer', () {
    test('executa só a última ação, 300 ms depois da última chamada', () {
      fakeAsync((async) {
        final chamadas = <String>[];
        final debouncer = Debouncer();

        debouncer.executar(() => chamadas.add('a'));
        async.elapse(const Duration(milliseconds: 200));
        debouncer.executar(() => chamadas.add('b'));
        async.elapse(const Duration(milliseconds: 299));
        expect(chamadas, isEmpty);
        async.elapse(const Duration(milliseconds: 2));
        expect(chamadas, ['b']);
      });
    });

    test('cancelar descarta a ação pendente', () {
      fakeAsync((async) {
        var rodou = false;
        final debouncer = Debouncer()..executar(() => rodou = true);
        debouncer.cancelar();
        async.elapse(const Duration(seconds: 1));
        expect(rodou, isFalse);
      });
    });

    test('pode ser usado de novo depois de executar', () {
      fakeAsync((async) {
        var vezes = 0;
        final debouncer = Debouncer();
        debouncer.executar(() => vezes++);
        async.elapse(const Duration(milliseconds: 400));
        debouncer.executar(() => vezes++);
        async.elapse(const Duration(milliseconds: 400));
        expect(vezes, 2);
      });
    });
  });
}
