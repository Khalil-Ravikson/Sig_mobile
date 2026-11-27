import 'package:freezed_annotation/freezed_annotation.dart';

import 'avaliacao.dart';
import 'docente.dart';
import 'notas.dart';

part 'turma_detalhe.freezed.dart';

/// O que a turma virtual mostra além do resumo da lista.
@freezed
abstract class TurmaDetalhe with _$TurmaDetalhe {
  const factory TurmaDetalhe({
    required String id,
    required String turma,
    required Notas notas,
    required List<Avaliacao> avaliacoes,
    required Docente docente,
  }) = _TurmaDetalhe;
}
