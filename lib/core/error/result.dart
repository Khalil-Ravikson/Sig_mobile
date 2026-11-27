import 'app_error.dart';

/// Resultado de uma operação: sucesso com dado, ou falha com [AppError].
sealed class Result<T> {
  const Result();
}

class Sucesso<T> extends Result<T> {
  const Sucesso(this.dado);

  final T dado;
}

class Falha<T> extends Result<T> {
  const Falha(this.erro);

  final AppError erro;
}
