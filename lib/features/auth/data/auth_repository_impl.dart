import 'package:dio/dio.dart';

import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/dio_error_mapper.dart';
import '../domain/auth_repository.dart';
import '../domain/resultado_login.dart';
import 'auth_api.dart';
import 'auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._api);

  final AuthApi _api;

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
}
