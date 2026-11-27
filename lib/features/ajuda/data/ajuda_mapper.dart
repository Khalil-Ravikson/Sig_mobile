import '../domain/ajuda.dart';
import 'ajuda_dto.dart';

/// Isola o formato do JSON (ou da API) do modelo do app.
class AjudaMapper {
  const AjudaMapper._();

  static Ajuda ajuda(AjudaDto dto) => Ajuda(
    perguntas: [
      for (final p in dto.perguntas)
        PerguntaFrequente(id: p.id, pergunta: p.pergunta, resposta: p.resposta),
    ],
    contatos: [
      for (final c in dto.contatos)
        ContatoAjuda(
          id: c.id,
          tipo: c.tipo == 'ctic' ? TipoContato.ctic : TipoContato.secretaria,
          titulo: c.titulo,
          descricao: c.descricao,
          email: c.email,
          telefone: c.telefone,
          horario: c.horario,
        ),
    ],
  );
}
