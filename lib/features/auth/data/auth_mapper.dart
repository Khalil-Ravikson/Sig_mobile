import '../domain/resultado_login.dart';
import '../domain/vinculo.dart';
import 'login_dto.dart';

/// Isola o formato da API do modelo do app.
class AuthMapper {
  const AuthMapper._();

  static ResultadoLogin resultadoLogin(LoginResponseDto dto) => ResultadoLogin(
    nome: dto.nome,
    vinculos: dto.vinculos.map(vinculo).toList(),
    tokenTemporario: dto.tokenTemporario,
  );

  static Vinculo vinculo(VinculoDto dto) => Vinculo(
    id: dto.id,
    tipo: _tipo(dto.tipo),
    descricao: dto.descricao,
    matricula: dto.matricula,
  );

  static TipoVinculo _tipo(String valor) => switch (valor.toUpperCase()) {
    'ALUNO' => TipoVinculo.aluno,
    'PROFESSOR' => TipoVinculo.professor,
    _ => TipoVinculo.servidor,
  };
}
