import '../../../core/error/result.dart';
import 'resultado_login.dart';

abstract interface class AuthRepository {
  Future<Result<ResultadoLogin>> login({
    required String cpf,
    required String senha,
  });

  /// Troca o token temporário pelo definitivo do vínculo e o guarda.
  Future<Result<void>> escolherVinculo({
    required int vinculoId,
    required String tokenTemporario,
  });

  /// Apaga o token guardado.
  Future<void> sair();
}
