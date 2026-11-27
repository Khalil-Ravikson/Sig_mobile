/// Tamanho do texto do app (multiplica o tamanho do sistema).
enum TamanhoTexto {
  pequeno('Pequeno', 0.9),
  medio('Médio', 1),
  grande('Grande', 1.15);

  const TamanhoTexto(this.rotulo, this.fator);

  final String rotulo;
  final double fator;
}

/// Preferências do app. No alpha ficam só em memória (voltam ao padrão quando
/// o app fecha).
class ConfiguracoesApp {
  const ConfiguracoesApp({
    this.tamanhoTexto = TamanhoTexto.medio,
    this.altoContraste = false,
    this.reduzirAnimacoes = false,
    this.digitalLigada = true,
  });

  final TamanhoTexto tamanhoTexto;
  final bool altoContraste;
  final bool reduzirAnimacoes;

  /// Entrar com a digital (simulada no alpha).
  final bool digitalLigada;

  ConfiguracoesApp copyWith({
    TamanhoTexto? tamanhoTexto,
    bool? altoContraste,
    bool? reduzirAnimacoes,
    bool? digitalLigada,
  }) => ConfiguracoesApp(
    tamanhoTexto: tamanhoTexto ?? this.tamanhoTexto,
    altoContraste: altoContraste ?? this.altoContraste,
    reduzirAnimacoes: reduzirAnimacoes ?? this.reduzirAnimacoes,
    digitalLigada: digitalLigada ?? this.digitalLigada,
  );

  @override
  bool operator ==(Object other) =>
      other is ConfiguracoesApp &&
      other.tamanhoTexto == tamanhoTexto &&
      other.altoContraste == altoContraste &&
      other.reduzirAnimacoes == reduzirAnimacoes &&
      other.digitalLigada == digitalLigada;

  @override
  int get hashCode =>
      Object.hash(tamanhoTexto, altoContraste, reduzirAnimacoes, digitalLigada);
}
