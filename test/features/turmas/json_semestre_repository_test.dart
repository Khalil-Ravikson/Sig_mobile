import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';
import 'package:siguema_mobile/features/turmas/data/json_semestre_repository.dart';
import 'package:siguema_mobile/features/turmas/domain/resumo_semestre.dart';

import '../../support/arquivos_bundle.dart';

void main() {
  JsonSemestreRepository novo({Map<String, int>? leituras}) =>
      JsonSemestreRepository(
        FonteJson(
          bundle: ArquivosBundle(leituras: leituras),
          latencia: FonteJson.semLatencia,
        ),
      );

  Future<ResumoSemestre> carregar() async {
    final resultado = await novo().carregarResumo();
    return (resultado as Sucesso<ResumoSemestre>).dado;
  }

  test('lê o resumo do semestre do JSON', () async {
    final resumo = await carregar();
    expect(resumo.semestre, '2026.2');
    expect(resumo.cr, 7.25);
    expect(resumo.integralizacaoPercentual, 87);
    expect(resumo.turmas, hasLength(3));
  });

  test('turma com nota e prova, e turma sem nada ainda', () async {
    final turmas = (await carregar()).turmas;
    expect(turmas[0].ultimaNota, 7.5);
    expect(turmas[0].proximaProva, DateTime(2026, 12, 3));
    expect(turmas[2].ultimaNota, isNull);
    expect(turmas[2].proximaProva, isNull);
    expect(turmas[2].local, isNull);
  });

  test('as próximas avaliações vêm no mesmo carregamento (sem N+1)', () async {
    final leituras = <String, int>{};
    final repositorio = novo(leituras: leituras);
    final resultado = await repositorio.carregarResumo();
    final resumo = (resultado as Sucesso<ResumoSemestre>).dado;
    expect(resumo.proximasAvaliacoes, hasLength(2));
    expect(resumo.proximasAvaliacoes.first.data, DateTime(2026, 12, 3));
    expect(leituras, {'assets/mock/turmas.json': 1});
  });

  test('Início e Turmas dividem uma só leitura do arquivo', () async {
    final leituras = <String, int>{};
    final repositorio = novo(leituras: leituras);
    await repositorio.carregarResumo();
    await repositorio.carregarResumo();
    expect(leituras['assets/mock/turmas.json'], 1);
  });

  test('os ids das avaliações existem entre as turmas', () async {
    final resumo = await carregar();
    final ids = resumo.turmas.map((t) => t.id).toSet();
    for (final avaliacao in resumo.proximasAvaliacoes) {
      expect(ids, contains(avaliacao.turmaId));
    }
  });

  test('CR e integralização de turmas.json batem com aluno.json', () async {
    final aluno =
        jsonDecode(File('assets/mock/aluno.json').readAsStringSync())
            as Map<String, dynamic>;
    final resumo = await carregar();
    expect(resumo.cr, (aluno['cr'] as num).toDouble());
    expect(
      resumo.integralizacaoPercentual,
      (aluno['integralizacao'] as Map<String, dynamic>)['percentual'],
    );
  });

  test('JSON quebrado vira Falha, nunca exceção', () async {
    final repositorio = JsonSemestreRepository(
      FonteJson(
        bundle: _BundleComTexto('{ isso não é json'),
        latencia: FonteJson.semLatencia,
      ),
    );
    final resultado = await repositorio.carregarResumo();
    expect((resultado as Falha).erro, isA<ErroDesconhecido>());
  });

  test(
    'data inválida sai da lista de avaliações sem derrubar a tela',
    () async {
      final repositorio = JsonSemestreRepository(
        FonteJson(
          bundle: _BundleComTexto(
            jsonEncode({
              'semestre': '2026.2',
              'indices': {'cr': 7, 'integralizacaoPercentual': 10},
              'turmas': <Object>[],
              'proximasAvaliacoes': [
                {'turmaId': 'x', 'titulo': 'Boa', 'data': '2026-12-03'},
                {'turmaId': 'x', 'titulo': 'Ruim', 'data': 'quando der'},
              ],
            }),
          ),
          latencia: FonteJson.semLatencia,
        ),
      );
      final resumo =
          ((await repositorio.carregarResumo()) as Sucesso<ResumoSemestre>)
              .dado;
      expect(resumo.cr, 7.0);
      expect(resumo.proximasAvaliacoes.map((a) => a.titulo), ['Boa']);
    },
  );
}

class _BundleComTexto extends ArquivosBundle {
  _BundleComTexto(this.texto);

  final String texto;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(texto)));
}
