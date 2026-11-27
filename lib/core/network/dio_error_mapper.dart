import 'package:dio/dio.dart';

import '../error/app_error.dart';

/// Traduz erros do dio para [AppError]. Não copia corpo nem cabeçalhos.
AppError mapearErroDio(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionError:
      return const SemConexao();
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode ?? 0;
      if (status == 401) return const NaoAutorizado();
      if (status >= 500) return const ErroServidor();
      return const ErroDesconhecido();
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const ErroDesconhecido();
  }
}
