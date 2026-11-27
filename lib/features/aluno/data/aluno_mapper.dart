import '../domain/aluno.dart';
import 'aluno_dto.dart';

/// Isola o formato do JSON (ou da API) do modelo do app. Status desconhecido
/// não vira "ativa" por engano: cai em "trancada" (mais cauteloso).
class AlunoMapper {
  const AlunoMapper._();

  static Aluno aluno(AlunoDto dto) => Aluno(
    nome: dto.nome,
    iniciais: dto.iniciais,
    matricula: dto.matricula,
    curso: dto.curso,
    nivel: dto.nivel,
    status: switch (dto.status) {
      'ativo' => StatusMatricula.ativa,
      'concluido' => StatusMatricula.concluida,
      _ => StatusMatricula.trancada,
    },
    entrada: dto.entrada,
    periodo: dto.periodo,
    cr: dto.cr.toDouble(),
    integralizacaoPercentual: dto.integralizacao.percentual,
    horasObrigatoriasFaltam: dto.integralizacao.horasObrigatoriasFaltam,
    horasOptativasFaltam: dto.integralizacao.horasOptativasFaltam,
    email: dto.email,
    telefone: dto.telefone,
  );
}
