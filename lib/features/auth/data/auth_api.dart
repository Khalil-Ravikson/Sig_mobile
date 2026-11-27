import 'package:dio/dio.dart';

import 'login_dto.dart';

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
}
