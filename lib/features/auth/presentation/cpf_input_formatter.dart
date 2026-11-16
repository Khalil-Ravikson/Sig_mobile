import 'package:flutter/services.dart';

import '../domain/cpf.dart';

/// Aplica a máscara 000.000.000-00 enquanto a pessoa digita.
class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue antigo,
    TextEditingValue novo,
  ) {
    var digitos = somenteDigitos(novo.text);
    if (digitos.length > 11) digitos = digitos.substring(0, 11);

    final saida = StringBuffer();
    for (var i = 0; i < digitos.length; i++) {
      if (i == 3 || i == 6) saida.write('.');
      if (i == 9) saida.write('-');
      saida.write(digitos[i]);
    }
    final texto = saida.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
