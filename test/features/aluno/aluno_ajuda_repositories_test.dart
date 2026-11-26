import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';
import 'package:siguema_mobile/features/ajuda/data/json_ajuda_repository.dart';
import 'package:siguema_mobile/features/ajuda/domain/ajuda.dart';
import 'package:siguema_mobile/features/aluno/data/json_aluno_repository.dart';
import 'package:siguema_mobile/features/aluno/domain/aluno.dart';

import '../../support/arquivos_bundle.dart';

class _BundleComTexto extends ArquivosBundle {
  _BundleComTexto(this.texto);

  final String texto;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(texto)));
}

FonteJson _fonte([ArquivosBundle? bundle]) => FonteJson(
  bundle: bundle ?? ArquivosBundle(),
  latencia: FonteJson.semLatencia,
);

Map<String, Object?> _aluno(String status) => {
  'nome': 'Fulana Teste',
  'iniciais': 'FT',
  'matricula': '1',
  'curso': 'Curso',
  'nivel': 'Graduação',
  'status': status,
  'entrada': '2020.1',
  'periodo': 3,
  'cr': 8,
  'integralizacao': {
    'percentual': 40,
    'horasObrigatoriasFaltam': 10,
    'horasOptativasFaltam': 5,
  },
  'email': 'x@exemplo.invalid',
  'telefone': '(00) 00000-0000',
};

void main() {
  group('JsonAlunoRepository', () {
    test('lê o discente do JSON', () async {
      final r = await JsonAlunoRepository(_fonte()).carregarAluno();
      final Aluno a = (r as Sucesso<Aluno>).dado;
      expect(a.nome, 'Ana Exemplo Souza');
      expect(a.iniciais, 'AS');
      expect(a.matricula, '2022000001');
      expect(a.status, StatusMatricula.ativa);
      expect(a.periodo, 7);
      expect(a.cr, 7.25);
      expect(a.integralizacaoPercentual, 87);
      expect(a.horasObrigatoriasFaltam, 480);
      expect(a.horasOptativasFaltam, 0);
      expect(a.email, endsWith('.invalid'));
    });

    test('status desconhecido nunca vira matrícula ativa', () async {
      for (final (texto, esperado) in [
        ('ativo', StatusMatricula.ativa),
        ('concluido', StatusMatricula.concluida),
        ('trancado', StatusMatricula.trancada),
        ('qualquer coisa', StatusMatricula.trancada),
      ]) {
        final repo = JsonAlunoRepository(
          _fonte(_BundleComTexto(jsonEncode(_aluno(texto)))),
        );
        final a = ((await repo.carregarAluno()) as Sucesso<Aluno>).dado;
        expect(a.status, esperado, reason: texto);
        expect(a.cr, 8.0);
      }
    });

    test('JSON quebrado vira Falha, nunca exceção', () async {
      final repo = JsonAlunoRepository(_fonte(_BundleComTexto('{ nada')));
      expect(
        ((await repo.carregarAluno()) as Falha).erro,
        isA<ErroDesconhecido>(),
      );
    });
  });

  group('JsonAjudaRepository', () {
    test('lê perguntas e contatos', () async {
      final r = await JsonAjudaRepository(_fonte()).carregarAjuda();
      final Ajuda a = (r as Sucesso<Ajuda>).dado;
      expect(a.perguntas.map((p) => p.pergunta), [
        'Esqueci minha senha',
        'Minha nota não apareceu',
        'Como pego o comprovante?',
        'Não vejo uma turma',
      ]);
      expect(a.perguntas.every((p) => p.resposta.isNotEmpty), isTrue);
      expect(a.contatos.map((c) => c.tipo), [
        TipoContato.ctic,
        TipoContato.secretaria,
      ]);
      expect(a.contatos.every((c) => c.email.endsWith('.invalid')), isTrue);
    });

    test('JSON quebrado vira Falha', () async {
      final repo = JsonAjudaRepository(_fonte(_BundleComTexto('[')));
      expect(
        ((await repo.carregarAjuda()) as Falha).erro,
        isA<ErroDesconhecido>(),
      );
    });
  });
}
