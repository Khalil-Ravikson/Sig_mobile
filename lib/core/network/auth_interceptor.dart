import 'package:dio/dio.dart';

import '../storage/token_store.dart';

/// Anexa `Authorization: Bearer <token>` nas chamadas, menos no login.
/// Respeita um `Authorization` já definido (ex.: o token temporário da escolha
/// de vínculo). Não escreve o token em log.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  static const _semToken = {'/auth/login'};

  final TokenStore _tokens;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final jaTem = options.headers.containsKey('Authorization');
    if (!jaTem && !_semToken.contains(options.path)) {
      final token = await _tokens.ler();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
