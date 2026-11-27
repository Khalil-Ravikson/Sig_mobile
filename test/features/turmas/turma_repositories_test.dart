import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';
import 'package:siguema_mobile/features/turmas/data/json_frequencia_repository.dart';
import 'package:siguema_mobile/features/turmas/data/json_semestre_repository.dart';
import 'package:siguema_mobile/features/turmas/data/json_turma_repository.dart';
import 'package:siguema_mobile/features/turmas/domain/frequencia_resumo.dart';
import 'package:siguema_mobile/features/turmas/domain/pagina_aulas.dart';
import 'package:siguema_mobile/features/turmas/domain/resumo_semestre.dart';
import 'package:siguema_mobile/features/turmas/domain/turma_detalhe.dart';

import '../../support/arquivos_bundle.dart';

void main() {
  late FonteJson fonte;
  late Map<String, int> leituras;
  late JsonTurmaRepository turmas;
  late JsonFrequenciaRepository frequencia;

  setUp(() {
    leituras = {};
    fonte = FonteJson(
      bundle: ArquivosBundle(leituras: leituras),
      latencia: FonteJson.semLatencia,
    );
    turmas = JsonTurmaRepository(fonte);
    frequencia = JsonFrequenciaRepository(fonte);
  });

  T dado<T>(Result<T> r) => (r as Sucesso<T>).dado;
  AppError erro<T>(Result<T> r) => (r as Falha<T>).erro;

  group('JsonTurmaRepository', () {
    test('lê notas, avaliações e docente', () async {
      final TurmaDetalhe t = dado(await turmas.carregarTurma('t01'));
      expect(t.turma, '01');
      expect(t.notas.n1, 5.0);
      expect(t.notas.n2, 7.5);
      expect(t.notas.n3, isNull);
      expect(t.notas.media, 6.3);
      expect(t.notas.provaFinal, isNull);
      expect(t.avaliacoes.single.data, DateTime(2026, 12, 3));
      expect(t.avaliacoes.single.hora, '08:00');
      expect(t.docente.nome, 'Helena Exemplo Prado');
    });

    test('turma sem notas nem avaliações vem vazia, não quebrada', () async {
      final TurmaDetalhe t = dado(await turmas.carregarTurma('t03'));
      expect(t.notas.media, isNull);
      expect(t.avaliacoes, isEmpty);
    });

    test('turma desconhecida é NaoEncontrado', () async {
      expect(erro(await turmas.carregarTurma('zzz')), isA<NaoEncontrado>());
    });

    test('o id da URL não vira caminho de arquivo', () async {
      for (final id in ['../usuarios', 't01/../../x', 'T01', '', 'a b']) {
        expect(erro(await turmas.carregarTurma(id)), isA<NaoEncontrado>());
      }
      expect(leituras, isEmpty);
    });
  });

  group('JsonFrequenciaRepository', () {
    test('resumo conta todas as aulas e faltas', () async {
      final FrequenciaResumo r = dado(await frequencia.carregarResumo('t01'));
      expect(r.totalAulas, 32);
      expect(r.totalFaltas, 2);
      expect(r.percentual, 94);
      expect(r.limiteFaltas, 8);
      expect(r.dentroDoLimite, isTrue);
      expect(r.minimoPercentual, 75);
      expect(r.pontos, hasLength(32));
      expect(r.pontos.where((p) => p), hasLength(2));
    });

    test('paginação: 20 + 12 e depois nada', () async {
      final PaginaAulas p0 = dado(await frequencia.carregarAulas('t01'));
      final PaginaAulas p1 = dado(
        await frequencia.carregarAulas('t01', pagina: 1),
      );
      final PaginaAulas p2 = dado(
        await frequencia.carregarAulas('t01', pagina: 2),
      );
      expect(p0.itens, hasLength(20));
      expect(p0.temMais, isTrue);
      expect(p1.itens, hasLength(12));
      expect(p1.temMais, isFalse);
      expect(p2.itens, isEmpty);
      expect(p2.temMais, isFalse);
    });

    test('mais recentes primeiro, sem repetir dias entre páginas', () async {
      final PaginaAulas p0 = dado(await frequencia.carregarAulas('t01'));
      final PaginaAulas p1 = dado(
        await frequencia.carregarAulas('t01', pagina: 1),
      );
      final datas = [...p0.itens, ...p1.itens].map((d) => d.data).toList();
      expect(datas.first, DateTime(2026, 11, 25));
      expect(datas.last, DateTime(2026, 8, 10));
      expect(datas.toSet(), hasLength(32));
      final ordenadas = [...datas]..sort((a, b) => b.compareTo(a));
      expect(datas, ordenadas);
    });

    test('tamanho de página e página negativa', () async {
      final PaginaAulas p = dado(
        await frequencia.carregarAulas('t01', pagina: -3, tamanho: 5),
      );
      expect(p.itens, hasLength(5));
      expect(p.temMais, isTrue);
    });

    test('páginas e resumo dividem uma só leitura do arquivo', () async {
      await frequencia.carregarResumo('t01');
      await frequencia.carregarAulas('t01');
      await frequencia.carregarAulas('t01', pagina: 1);
      expect(leituras['assets/mock/frequencia_t01.json'], 1);
    });

    test('turma sem aulas: 100% e lista vazia', () async {
      final FrequenciaResumo r = dado(await frequencia.carregarResumo('t03'));
      expect(r.totalAulas, 0);
      expect(r.percentual, 100);
      expect(dado(await frequencia.carregarAulas('t03')).itens, isEmpty);
    });

    test('turma desconhecida é NaoEncontrado', () async {
      expect(
        erro(await frequencia.carregarResumo('zzz')),
        isA<NaoEncontrado>(),
      );
      expect(
        erro(await frequencia.carregarAulas('../x')),
        isA<NaoEncontrado>(),
      );
    });
  });

  test(
    'a frequência de turmas.json bate com a de frequencia_<id>.json',
    () async {
      final ResumoSemestre resumo = dado(
        await JsonSemestreRepository(fonte).carregarResumo(),
      );
      for (final turma in resumo.turmas) {
        final FrequenciaResumo f = dado(
          await frequencia.carregarResumo(turma.id),
        );
        expect(
          f.percentual,
          turma.frequenciaPercentual,
          reason: 'turma ${turma.id}',
        );
        // E toda turma da lista tem o seu detalhe.
        expect(dado(await turmas.carregarTurma(turma.id)).id, turma.id);
      }
    },
  );
}
