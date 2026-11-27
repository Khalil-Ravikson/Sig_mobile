import 'package:freezed_annotation/freezed_annotation.dart';

part 'ajuda.freezed.dart';

@freezed
abstract class PerguntaFrequente with _$PerguntaFrequente {
  const factory PerguntaFrequente({
    required String id,
    required String pergunta,
    required String resposta,
  }) = _PerguntaFrequente;
}

enum TipoContato { ctic, secretaria }

@freezed
abstract class ContatoAjuda with _$ContatoAjuda {
  const factory ContatoAjuda({
    required String id,
    required TipoContato tipo,
    required String titulo,
    required String descricao,
    required String email,
    required String telefone,
    required String horario,
  }) = _ContatoAjuda;
}

@freezed
abstract class Ajuda with _$Ajuda {
  const factory Ajuda({
    required List<PerguntaFrequente> perguntas,
    required List<ContatoAjuda> contatos,
  }) = _Ajuda;
}
