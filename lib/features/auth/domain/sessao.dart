import 'resultado_login.dart';
import 'vinculo.dart';

/// Estado da sessão: quem entrou e com qual vínculo.
/// Fica só em memória; guardar o token de forma segura é outra tarefa (T-21).
class Sessao {
  const Sessao({this.login, this.vinculo});

  static const vazia = Sessao();

  final ResultadoLogin? login;
  final Vinculo? vinculo;

  bool get logado => login != null;
  bool get vinculoEscolhido => vinculo != null;
}
