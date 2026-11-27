import 'package:freezed_annotation/freezed_annotation.dart';

import 'aula_dia.dart';

part 'pagina_aulas.freezed.dart';

/// Uma fatia do mapa de frequência (mais recentes primeiro).
@freezed
abstract class PaginaAulas with _$PaginaAulas {
  const factory PaginaAulas({
    required List<AulaDia> itens,
    required bool temMais,
  }) = _PaginaAulas;
}
