/// Mantém só os dígitos.
String somenteDigitos(String valor) => valor.replaceAll(RegExp(r'\D'), '');

/// O login só confere o tamanho (11 dígitos). Quem valida o CPF de fato é o
/// servidor.
bool cpfTemOnzeDigitos(String valor) => somenteDigitos(valor).length == 11;
