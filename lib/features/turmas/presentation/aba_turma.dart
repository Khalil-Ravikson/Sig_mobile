/// Abas da turma virtual. O nome (`name`) é o valor de `?aba=` na URL.
enum AbaTurma {
  resumo('Resumo'),
  frequencia('Frequência'),
  notas('Notas'),
  materiais('Materiais', emBreve: true),
  atividades('Atividades', emBreve: true);

  const AbaTurma(this.rotulo, {this.emBreve = false});

  final String rotulo;

  /// Fase 2: o chip existe, mas a área ainda não.
  final bool emBreve;

  /// `?aba=` desconhecido ou ausente cai no Resumo.
  static AbaTurma ler(String? valor) => AbaTurma.values.firstWhere(
    (aba) => aba.name == valor,
    orElse: () => AbaTurma.resumo,
  );
}
