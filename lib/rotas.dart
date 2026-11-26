/// Caminhos do app. Ficam à parte para as telas poderem navegar sem importar
/// o router (e o router importar as telas).
abstract final class Rotas {
  static const login = '/login';
  static const vinculo = '/vinculo';

  // Abas (com barra inferior).
  static const inicio = '/inicio';
  static const turmas = '/turmas';
  static const documentos = '/documentos';

  // Por cima das abas (sem barra inferior).
  static const perfil = '/perfil';
  static const perfilDados = '/perfil/dados';
  static const perfilConfig = '/perfil/config';
  static const perfilAjuda = '/perfil/ajuda';

  /// Turma virtual. A aba vive na URL (`?aba=`), para voltar e compartilhar
  /// funcionarem.
  static String turma(String id, {String? aba}) =>
      aba == null ? '/turmas/$id' : '/turmas/$id?aba=$aba';
}
