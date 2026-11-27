/// Erros do app, sem dados pessoais nas mensagens.
sealed class AppError implements Exception {
  const AppError(this.mensagem);

  final String mensagem;

  @override
  String toString() => '$runtimeType: $mensagem';
}

class SemConexao extends AppError {
  const SemConexao() : super('Sem conexão com o servidor.');
}

class NaoAutorizado extends AppError {
  const NaoAutorizado() : super('CPF ou senha inválidos.');
}

class SessaoExpirada extends AppError {
  const SessaoExpirada() : super('Sua sessão expirou. Entre de novo.');
}

class NaoEncontrado extends AppError {
  const NaoEncontrado() : super('Não encontramos o que você procurava.');
}

class ErroServidor extends AppError {
  const ErroServidor() : super('Erro no servidor. Tente novamente.');
}

class ErroDesconhecido extends AppError {
  const ErroDesconhecido() : super('Algo deu errado.');
}
