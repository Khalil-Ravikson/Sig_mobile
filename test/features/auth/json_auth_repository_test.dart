import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';
import 'package:siguema_mobile/features/auth/data/json_auth_repository.dart';
import 'package:siguema_mobile/features/auth/domain/resultado_login.dart';
import 'package:siguema_mobile/features/auth/domain/vinculo.dart';

import '../../support/arquivos_bundle.dart';

void main() {
  late JsonAuthRepository repositorio;

  setUp(() {
    repositorio = JsonAuthRepository(
      FonteJson(bundle: ArquivosBundle(), latencia: FonteJson.semLatencia),
    );
  });

  Future<Result<dynamic>> entrar(String cpf, String senha) =>
      repositorio.login(cpf: cpf, senha: senha);

  test('CPF e senha de demonstração entram com um vínculo', () async {
    final resultado = await repositorio.login(
      cpf: '00000000001',
      senha: 'alpha123',
    );
    expect(resultado, isA<Sucesso<dynamic>>());
    final login = (resultado as Sucesso).dado;
    expect(login.nome, 'Ana Exemplo Souza');
    expect(login.vinculos, hasLength(1));
    expect(login.vinculos.single.tipo, TipoVinculo.aluno);
    expect(login.tokenTemporario, isNotEmpty);
  });

  test('o usuário de dois vínculos mostra a escolha', () async {
    final resultado = await repositorio.login(
      cpf: '00000000002',
      senha: 'alpha123',
    );
    expect((resultado as Sucesso).dado.vinculos, hasLength(2));
  });

  test('docente e servidor vêm como vínculos distintos', () async {
    final resultado = await repositorio.login(
      cpf: '00000000003',
      senha: 'alpha123',
    );
    final login = (resultado as Sucesso<ResultadoLogin>).dado;
    final tipos = login.vinculos.map((v) => v.tipo);
    expect(tipos, [TipoVinculo.professor, TipoVinculo.servidor]);
  });

  test('o usuário sem vínculo entra com a lista vazia', () async {
    final resultado = await repositorio.login(
      cpf: '00000000004',
      senha: 'alpha123',
    );
    expect((resultado as Sucesso).dado.vinculos, isEmpty);
  });

  test('senha errada ou CPF desconhecido dão NaoAutorizado', () async {
    for (final tentativa in [
      ('00000000001', 'errada'),
      ('99999999999', 'alpha123'),
      ('', ''),
    ]) {
      final resultado = await entrar(tentativa.$1, tentativa.$2);
      expect(resultado, isA<Falha<dynamic>>());
      expect((resultado as Falha).erro, isA<NaoAutorizado>());
    }
  });

  test('escolher vínculo e sair não falham e não guardam nada', () async {
    final escolha = await repositorio.escolherVinculo(
      vinculoId: 1,
      tokenTemporario: 'tmp-alpha',
    );
    expect(escolha, isA<Sucesso<void>>());
    await repositorio.sair();
  });

  test('arquivo ausente vira ErroDesconhecido, sem lançar', () async {
    final semArquivos = JsonAuthRepository(
      FonteJson(bundle: _BundleVazio(), latencia: FonteJson.semLatencia),
    );
    final resultado = await semArquivos.login(cpf: '1', senha: '1');
    expect((resultado as Falha).erro, isA<ErroDesconhecido>());
  });
}

class _BundleVazio extends ArquivosBundle {
  @override
  Future<ByteData> load(String key) => throw StateError('vazio');
}
