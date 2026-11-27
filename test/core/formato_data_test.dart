import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/util/formato_data.dart';
import 'package:siguema_mobile/core/util/iniciais.dart';

void main() {
  final hoje = DateTime(2026, 11, 25);

  group('FormatoData', () {
    test('lê datas ISO e ignora valores inválidos', () {
      expect(FormatoData.lerData('2026-12-03'), DateTime(2026, 12, 3));
      expect(FormatoData.lerData(null), isNull);
      expect(FormatoData.lerData(''), isNull);
      expect(FormatoData.lerData('não é data'), isNull);
    });

    test('formata dia, mês e dia/mês', () {
      final data = DateTime(2026, 12, 3);
      expect(FormatoData.dia(data), '03');
      expect(FormatoData.mesAbreviado(data), 'DEZ');
      expect(FormatoData.diaMes(data), '03/12');
    });

    test('dia da semana em português', () {
      expect(FormatoData.diaSemanaDiaMes(hoje), 'Quarta, 25/11');
    });

    test('diz quantos dias faltam', () {
      expect(FormatoData.emDias(DateTime(2026, 11, 25), hoje), 'Hoje');
      expect(FormatoData.emDias(DateTime(2026, 11, 26), hoje), 'Amanhã');
      expect(FormatoData.emDias(DateTime(2026, 12, 3), hoje), 'Em 8 dias');
      expect(FormatoData.emDias(DateTime(2026, 12, 10), hoje), 'Em 15 dias');
      expect(FormatoData.emDias(DateTime(2026, 11, 20), hoje), 'Já passou');
    });

    test('conta dias de calendário, não de 24 h', () {
      // Hora do dia não muda o resultado.
      expect(
        FormatoData.diasAte(
          DateTime(2026, 12, 3, 23),
          DateTime(2026, 11, 25, 1),
        ),
        8,
      );
    });

    test('nome do mês, dia da semana curto e hora', () {
      expect(FormatoData.nomeMes(DateTime(2026, 9, 9)), 'Setembro');
      expect(FormatoData.nomeMes(DateTime(2026, 3, 1)), 'Março');
      expect(FormatoData.diaSemanaCurto(DateTime(2026, 9, 9)), 'Qua');
      expect(FormatoData.diaSemanaCurto(DateTime(2026, 9, 14)), 'Seg');
      expect(FormatoData.hora('13:10'), '13h10');
      expect(FormatoData.hora(null), isNull);
      expect(FormatoData.hora(''), isNull);
      expect(FormatoData.minusculaInicial('Em 15 dias'), 'em 15 dias');
      expect(FormatoData.minusculaInicial(''), '');
    });

    test('notas com vírgula e traço para ausente', () {
      expect(FormatoData.nota(7.5), '7,5');
      expect(FormatoData.nota(8), '8');
      expect(FormatoData.nota(null), '—');
      expect(FormatoData.notaUmaCasa(5), '5,0');
      expect(FormatoData.notaUmaCasa(6.3), '6,3');
      expect(FormatoData.notaUmaCasa(null), '—');
      expect(FormatoData.duasCasas(7.25), '7,25');
      expect(FormatoData.duasCasas(7), '7,00');
    });
  });

  group('iniciaisDe', () {
    test('primeira e última', () {
      expect(iniciaisDe('Ana Exemplo Souza'), 'AS');
      expect(iniciaisDe('Ana'), 'A');
      expect(iniciaisDe('  '), '');
    });
  });
}
