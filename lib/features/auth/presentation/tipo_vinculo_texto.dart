import 'package:flutter/material.dart';

import '../domain/vinculo.dart';

/// Textos e ícones de cada tipo de vínculo na interface.
extension TipoVinculoTexto on TipoVinculo {
  String get titulo => switch (this) {
    TipoVinculo.aluno => 'Portal do Discente',
    TipoVinculo.professor => 'Portal do Docente',
    TipoVinculo.servidor => 'Portal do Servidor',
  };

  IconData get icone => switch (this) {
    TipoVinculo.aluno => Icons.school_outlined,
    TipoVinculo.professor => Icons.menu_book_outlined,
    TipoVinculo.servidor => Icons.badge_outlined,
  };
}
