import '../../../core/error/app_error.dart';
import '../../../core/error/result.dart';
import '../../../core/mock/fonte_json.dart';
import '../domain/auth_repository.dart';
import '../domain/resultado_login.dart';
import 'auth_mapper.dart';
import 'usuarios_demo_dto.dart';

/// Login falso do alpha: confere CPF e senha de demonstração contra
/// `assets/mock/usuarios.json`. Não chama rede nem guarda nada no aparelho
/// (o token é só um texto fixo na memória da sessão).
class JsonAuthRepository implements AuthRepository {
  const JsonAuthRepository(this._fonte);

  final FonteJson _fonte;

  static const _arquivo = 'usuarios.json';
  static const _tokenFalso = 'tmp-alpha';

  @override
  Future<Result<ResultadoLogin>> login({
    required String cpf,
    required String senha,
  }) async {
    try {
      final json = await _fonte.ler(_arquivo);
      final usuarios = UsuariosDemoDto.fromJson(
        json! as Map<String, dynamic>,
      ).usuarios;
      for (final usuario in usuarios) {
        if (usuario.cpf == cpf && usuario.senhaDemo == senha) {
          return Sucesso(
            ResultadoLogin(
              nome: usuario.nome,
              vinculos: usuario.vinculos.map(AuthMapper.vinculo).toList(),
              tokenTemporario: _tokenFalso,
            ),
          );
        }
      }
      return const Falha(NaoAutorizado());
    } on Object {
      return const Falha(ErroDesconhecido());
    }
  }

  @override
  Future<Result<void>> escolherVinculo({
    required int vinculoId,
    required String tokenTemporario,
  }) async => const Sucesso<void>(null);

  @override
  Future<void> sair() async {}
}
