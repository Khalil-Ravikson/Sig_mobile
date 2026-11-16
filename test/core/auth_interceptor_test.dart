import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/network/auth_interceptor.dart';

import '../support/fake_token_store.dart';

/// Captura o que o dio enviaria, sem rede.
class _Captura implements HttpClientAdapter {
  RequestOptions? ultima;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    ultima = options;
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late FakeTokenStore tokens;
  late _Captura captura;
  late Dio dio;

  setUp(() {
    tokens = FakeTokenStore();
    captura = _Captura();
    dio = Dio(BaseOptions(baseUrl: 'http://teste'))
      ..httpClientAdapter = captura
      ..interceptors.add(AuthInterceptor(tokens));
  });

  test('anexa o Bearer quando há token', () async {
    tokens.token = 'abc';
    await dio.get<void>('/algo');
    expect(captura.ultima?.headers['Authorization'], 'Bearer abc');
  });

  test('não anexa nada sem token', () async {
    await dio.get<void>('/algo');
    expect(captura.ultima?.headers.containsKey('Authorization'), isFalse);
  });

  test('não anexa o token no login', () async {
    tokens.token = 'abc';
    await dio.post<void>('/auth/login');
    expect(captura.ultima?.headers.containsKey('Authorization'), isFalse);
  });

  test('respeita um Authorization já definido', () async {
    tokens.token = 'abc';
    await dio.post<void>(
      '/auth/vinculo',
      options: Options(headers: {'Authorization': 'Bearer tmp-1'}),
    );
    expect(captura.ultima?.headers['Authorization'], 'Bearer tmp-1');
  });
}
