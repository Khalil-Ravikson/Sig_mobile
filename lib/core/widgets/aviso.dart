import 'package:flutter/material.dart';

import '../theme/app_space.dart';

/// Mostra uma mensagem curta, flutuando acima da barra inferior quando houver.
void mostrarAviso(
  BuildContext context,
  String mensagem, {
  double margemInferior = AppSpace.s24,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(mensagem),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(
          AppSpace.margemTela,
          0,
          AppSpace.margemTela,
          margemInferior,
        ),
      ),
    );
}
