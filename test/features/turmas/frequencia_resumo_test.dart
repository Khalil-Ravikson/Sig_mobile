import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/features/turmas/domain/frequencia_resumo.dart';
import 'package:siguema_mobile/features/turmas/presentation/aba_turma.dart';

FrequenciaResumo _r(int aulas, int faltas, {int minimo = 75}) =>
    FrequenciaResumo(
      minimoPercentual: minimo,
      totalAulas: aulas,
      totalFaltas: faltas,
      pontos: const [],
    );

void main() {
  group('FrequenciaResumo', () {
    test('2 faltas em 32 aulas: 94%, limite de 8', () {
      final r = _r(32, 2);
      expect(r.percentual, 94);
      expect(r.limiteFaltas, 8);
      expect(r.dentroDoLimite, isTrue);
    });

    test('exatamente no limite ainda está dentro', () {
      expect(_r(32, 8).dentroDoLimite, isTrue);
      expect(_r(32, 8).percentual, 75);
    });

    test('uma falta além do limite sai do limite', () {
      expect(_r(32, 9).dentroDoLimite, isFalse);
      expect(_r(32, 9).percentual, 72);
    });

    test('limite arredonda para baixo', () {
      // 30 aulas: 25% = 7,5 → 7 faltas.
      expect(_r(30, 0).limiteFaltas, 7);
      expect(_r(30, 8).dentroDoLimite, isFalse);
    });

    test('sem aulas: 100% e dentro do limite', () {
      final r = _r(0, 0);
      expect(r.percentual, 100);
      expect(r.limiteFaltas, 0);
      expect(r.dentroDoLimite, isTrue);
    });
  });

  group('AbaTurma.ler', () {
    test('lê o valor da URL', () {
      expect(AbaTurma.ler('frequencia'), AbaTurma.frequencia);
      expect(AbaTurma.ler('notas'), AbaTurma.notas);
      expect(AbaTurma.ler('materiais'), AbaTurma.materiais);
    });

    test('ausente ou desconhecido cai no Resumo', () {
      expect(AbaTurma.ler(null), AbaTurma.resumo);
      expect(AbaTurma.ler('xyz'), AbaTurma.resumo);
      expect(AbaTurma.ler('Frequencia'), AbaTurma.resumo);
    });

    test('só Materiais e Atividades são "em breve"', () {
      final emBreve = AbaTurma.values.where((a) => a.emBreve);
      expect(emBreve, [AbaTurma.materiais, AbaTurma.atividades]);
    });
  });
}
