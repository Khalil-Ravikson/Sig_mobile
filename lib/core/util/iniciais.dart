/// Iniciais para o avatar: primeira letra do primeiro e do último nome.
String iniciaisDe(String nome) {
  final partes = nome.split(' ').where((p) => p.isNotEmpty).toList();
  if (partes.isEmpty) return '';
  if (partes.length == 1) return partes.first[0].toUpperCase();
  return (partes.first[0] + partes.last[0]).toUpperCase();
}
