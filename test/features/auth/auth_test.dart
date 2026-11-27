import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/features/auth/data/auth_api.dart';
import 'package:siguema_mobile/features/auth/data/auth_mapper.dart';
import 'package:siguema_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:siguema_mobile/features/auth/data/login_dto.dart';
import 'package:siguema_mobile/features/auth/data/vinculo_dto.dart';
import 'package:siguema_mobile/features/auth/domain/vinculo.dart';
import 'package:siguema_mobile/features/auth/presentation/auth_providers.dart';
import 'package:siguema_mobile/features/auth/presentation/login_view_model.dart';

import '../../support/fake_token_store.dart';

class _MockAuthApi extends Mock implements AuthApi {}

const _dto = LoginResponseDto(
  nome: 'Maria Teste',
  vinculos: [
    VinculoDto(id: 1, tipo: 'ALUNO', descricao: 'Engenharia Civil'),
    VinculoDto(id: 2, tipo: 'PROFESSOR', descricao: 'Matemática'),
  ],
  tokenTemporario: 'tmp',
);

void main() {
  group('AuthMapper', () {
    test('converte DTO em modelo do app', () {
      final r = AuthMapper.resultadoLogin(_dto);
      expect(r.vinculos, hasLength(2));
      expect(r.vinculos.first.tipo, TipoVinculo.aluno);
      expect(r.vinculos.last.tipo, TipoVinculo.professor);
    });
  });

  group('AuthRepositoryImpl', () {
    late _MockAuthApi api;
    late FakeTokenStore tokens;
    late AuthRepositoryImpl repo;

    setUp(() {
      api = _MockAuthApi();
      tokens = FakeTokenStore();
      repo = AuthRepositoryImpl(api, tokens);
    });

    test('escolher vínculo guarda o token definitivo', () async {
      when(() => api.escolherVinculo(1, 'tmp')).thenAnswer(
        (_) async =>
            const EscolhaVinculoResponseDto(token: 'tok-def', expiraEm: 900),
      );
      final r = await repo.escolherVinculo(
        vinculoId: 1,
        tokenTemporario: 'tmp',
      );
      expect(r, isA<Sucesso<void>>());
      expect(tokens.token, 'tok-def');
    });

    test('escolher vínculo com 401 vira SessaoExpirada e não guarda', () async {
      when(() => api.escolherVinculo(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response<void>(
            requestOptions: RequestOptions(),
            statusCode: 401,
          ),
        ),
      );
      final r = await repo.escolherVinculo(
        vinculoId: 1,
        tokenTemporario: 'velho',
      );
      expect((r as Falha<void>).erro, isA<SessaoExpirada>());
      expect(tokens.token, isNull);
    });

    test('sair apaga o token', () async {
      tokens.token = 'tok-def';
      await repo.sair();
      expect(tokens.token, isNull);
    });

    test('devolve Sucesso com o modelo mapeado', () async {
      when(() => api.login(any(), any())).thenAnswer((_) async => _dto);
      final r = await repo.login(cpf: '00000000001', senha: 'x');
      expect(r, isA<Sucesso<dynamic>>());
    });

    test('401 vira NaoAutorizado', () async {
      when(() => api.login(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response<void>(
            requestOptions: RequestOptions(),
            statusCode: 401,
          ),
        ),
      );
      final r = await repo.login(cpf: '00000000001', senha: 'x');
      expect(r, isA<Falha<dynamic>>());
      expect((r as Falha<dynamic>).erro, isA<NaoAutorizado>());
    });
  });

  group('LoginViewModel', () {
    test('entrar com sucesso publica o resultado', () async {
      final api = _MockAuthApi();
      when(() => api.login(any(), any())).thenAnswer((_) async => _dto);
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            AuthRepositoryImpl(api, FakeTokenStore()),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(loginViewModelProvider.future);
      await container
          .read(loginViewModelProvider.notifier)
          .entrar('00000000001', 'x');

      expect(container.read(loginViewModelProvider).value?.nome, 'Maria Teste');
    });
  });
}
