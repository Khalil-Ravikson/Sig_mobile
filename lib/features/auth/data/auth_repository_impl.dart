import 'package:dio/dio.dart';

import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/dio_error_mapper.dart';
import '../../../core/storage/token_store.dart';
import '../domain/auth_repository.dart';
import '../domain/resultado_login.dart';
import 'auth_api.dart';
import 'auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._api, this._tokens);

  final AuthApi _api;
  final TokenStore _tokens;

  @override
  Future<Result<ResultadoLogin>> login({
    required String cpf,
    required String senha,
  }) async {
    try {
      final dto = await _api.login(cpf, senha);
      return Sucesso(AuthMapper.resultadoLogin(dto));
    } on DioException catch (e) {
      return Falha(mapearErroDio(e));
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }

  @override
  Future<Result<void>> escolherVinculo({
    required int vinculoId,
    required String tokenTemporario,
  }) async {
    try {
      final dto = await _api.escolherVinculo(vinculoId, tokenTemporario);
      await _tokens.salvar(dto.token);
      return const Sucesso<void>(null);
    } on DioException catch (e) {
      // Aqui o 401 é o token temporário vencido, não senha errada.
      if (e.response?.statusCode == 401) return const Falha(SessaoExpirada());
      return Falha(mapearErroDio(e));
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }

  @override
  Future<void> sair() async {
    try {
      await _tokens.apagar();
    } on Object {
      // Sair nunca deve travar por falha do cofre.
    }
  }
}
