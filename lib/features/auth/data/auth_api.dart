import 'package:dio/dio.dart';

import 'login_dto.dart';
import 'vinculo_dto.dart';

/// Única classe da feature que fala com o `dio`.
class AuthApi {
  const AuthApi(this._dio);

  final Dio _dio;

  Future<LoginResponseDto> login(String cpf, String senha) async {
    final resposta = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'cpf': cpf, 'senha': senha},
    );
    return LoginResponseDto.fromJson(resposta.data!);
  }

  /// Troca o token temporário do login pelo token definitivo do vínculo.
  Future<EscolhaVinculoResponseDto> escolherVinculo(
    int vinculoId,
    String tokenTemporario,
  ) async {
    final resposta = await _dio.post<Map<String, dynamic>>(
      '/auth/vinculo',
      data: {'vinculoId': vinculoId},
      options: Options(headers: {'Authorization': 'Bearer $tokenTemporario'}),
    );
    return EscolhaVinculoResponseDto.fromJson(resposta.data!);
  }
}
