/// Turma do discente no semestre.
class Turma {
  const Turma({
    required this.disciplina,
    required this.horario,
    required this.curso,
    this.novidades = 0,
  });

  final String disciplina;
  final String horario;
  final String curso;

  /// Quantidade de novidades não vistas (avisos, atividades).
  final int novidades;
}
