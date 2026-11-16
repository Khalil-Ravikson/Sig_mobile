import '../../../core/error/result.dart';
import 'resultado_login.dart';

abstract interface class AuthRepository {
  Future<Result<ResultadoLogin>> login({
    required String cpf,
    required String senha,
  });
}
