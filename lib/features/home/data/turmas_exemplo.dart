import '../domain/turma.dart';

/// DADOS DE EXEMPLO, copiados do Figma (DISC-02 A), até a API de turmas
/// existir. Substituir por um Repository quando o contrato for definido.
const turmasExemplo = <Turma>[
  Turma(
    disciplina: 'Ciência e Tecnologia dos Materiais',
    horario: 'Seg e qua · manhã · 3º e 4º horário',
    curso: 'Engenharia de Computação · CCT',
    novidades: 1,
  ),
  Turma(
    disciplina: 'Análise e Processamento de Sinais',
    horario: 'Seg e qua · tarde · 3º e 4º; qui · tarde · 1º e 2º',
    curso: 'Engenharia de Computação · CCT',
  ),
  Turma(
    disciplina: 'Projeto de Trabalho de Conclusão de Curso',
    horario: 'Sem horário fixo',
    curso: 'Engenharia de Computação · CCT',
    novidades: 1,
  ),
];

/// Próxima aula de exemplo (DISC-03 D), com o dia em texto.
const proximaAulaExemplo = (
  turma: 0,
  quando: 'Seg, 02/11 · manhã · 3º e 4º horário',
);
