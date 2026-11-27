import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config_provider.dart';
import '../storage/token_store.dart';
import 'auth_interceptor.dart';

/// Cliente HTTP único do app. Só as classes `*_api` devem usá-lo.
/// Refresh de token fica de fora até a API real dizer se existe.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(AuthInterceptor(ref.watch(tokenStoreProvider)));
  return dio;
});
