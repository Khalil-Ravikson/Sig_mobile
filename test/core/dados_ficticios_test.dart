import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Trava de LGPD: tudo em `assets/mock/` precisa ser claramente fictício.
/// Se alguém colar um dado real num JSON, estes testes quebram.
void main() {
  final arquivos = Directory('assets/mock')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList();

  /// Todos os textos (valores e chaves) do JSON, em lista.
  Iterable<String> textos(Object? no) sync* {
    if (no is String) {
      yield no;
    } else if (no is List) {
      for (final item in no) {
        yield* textos(item);
      }
    } else if (no is Map) {
      for (final e in no.entries) {
        yield* textos(e.value);
      }
    }
  }

  test('há arquivos de dados do alpha', () {
    expect(arquivos.length, greaterThanOrEqualTo(8));
  });

  for (final arquivo in arquivos) {
    final nome = arquivo.uri.pathSegments.last;
    final valores = textos(jsonDecode(arquivo.readAsStringSync())).toList();

    test('$nome: CPFs só os fictícios (0000000000N)', () {
      for (final v in valores) {
        if (RegExp(r'^\d{11}$').hasMatch(v)) {
          expect(v, matches(RegExp(r'^0{10}\d$')), reason: 'CPF em $nome');
        }
        // CPF formatado não deve aparecer.
        expect(v, isNot(matches(RegExp(r'\d{3}\.\d{3}\.\d{3}-\d{2}'))));
      }
    });

    test('$nome: e-mails só em domínio .invalid', () {
      for (final v in valores) {
        for (final m in RegExp(r'[\w.+-]+@[\w.-]+').allMatches(v)) {
          expect(m.group(0), endsWith('.invalid'), reason: 'e-mail em $nome');
        }
      }
    });

    test('$nome: telefones só no formato fictício (98) 9000x-000x', () {
      for (final v in valores) {
        for (final m in RegExp(r'\(\d{2}\) \d{4,5}-\d{4}').allMatches(v)) {
          expect(
            m.group(0),
            matches(RegExp(r'^\(98\) 9000\d-000\d$')),
            reason: 'telefone em $nome',
          );
        }
      }
    });
  }

  test('nomes de pessoas trazem "Exemplo" (nunca um nome real)', () {
    final nomes = <String>[];
    void colher(Object? no) {
      if (no is Map) {
        for (final e in no.entries) {
          if (e.key == 'nome' && e.value is String) {
            nomes.add(e.value as String);
          }
          colher(e.value);
        }
      } else if (no is List) {
        for (final item in no) {
          colher(item);
        }
      }
    }

    for (final arquivo in arquivos) {
      colher(jsonDecode(arquivo.readAsStringSync()));
    }
    // Usuários (4), aluno (1) e os docentes das turmas (3).
    expect(nomes.length, greaterThanOrEqualTo(8));
    for (final n in nomes) {
      expect(n, contains('Exemplo'), reason: n);
    }
  });

  test('a senha de demonstração existe só em usuarios.json', () {
    for (final arquivo in arquivos) {
      final nome = arquivo.uri.pathSegments.last;
      final conteudo = arquivo.readAsStringSync();
      if (nome == 'usuarios.json') {
        expect(conteudo, contains('senhaDemo'));
      } else {
        expect(conteudo, isNot(contains('senhaDemo')), reason: nome);
      }
    }
  });
}
