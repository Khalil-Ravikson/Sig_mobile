/// Texto para comparar na busca: minúsculo, sem acento e sem espaços nas
/// pontas ("Declaração" casa com "declaracao").
String normalizarParaBusca(String texto) {
  const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  const semAcento = 'aaaaaeeeeiiiiooooouuuucn';
  final buffer = StringBuffer();
  for (final letra in texto.trim().toLowerCase().split('')) {
    final i = comAcento.indexOf(letra);
    buffer.write(i < 0 ? letra : semAcento[i]);
  }
  return buffer.toString();
}
