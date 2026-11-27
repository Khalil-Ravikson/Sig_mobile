import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/util/formato_data.dart';
import '../../aluno/domain/aluno.dart';
import '../../aluno/presentation/aluno_providers.dart';

part 'perfil_view_model.g.dart';

/// Situação da matrícula para o selo (texto + tom).
class SituacaoUi {
  const SituacaoUi({required this.texto, required this.positiva});

  final String texto;
  final bool positiva;
}

/// Perfil pronto para exibir.
class PerfilUi {
  const PerfilUi({
    required this.subtitulo,
    required this.situacao,
    required this.cr,
    required this.periodo,
    required this.integralizacao,
    required this.integralizacaoPercentual,
    required this.faltam,
  });

  /// `Discente · Matrícula 2022000001`
  final String subtitulo;

  /// `Matrícula ativa`
  final SituacaoUi situacao;
  final String cr;
  final String periodo;
  final String integralizacao;
  final int integralizacaoPercentual;

  /// `Faltam 480 h obrigatórias e 0 h optativas.`
  final String faltam;
}

/// Linhas da tela Meus dados (só leitura).
class MeusDadosUi {
  const MeusDadosUi({
    required this.matricula,
    required this.curso,
    required this.nivel,
    required this.situacao,
    required this.entrada,
    required this.email,
    required this.telefone,
  });

  final String matricula;
  final String curso;
  final String nivel;
  final SituacaoUi situacao;
  final String entrada;
  final String email;
  final String telefone;
}

@riverpod
Future<PerfilUi> perfilViewModel(Ref ref) async {
  final aluno = await ref.watch(alunoProvider.future);
  return PerfilUi(
    subtitulo: 'Discente · Matrícula ${aluno.matricula}',
    situacao: switch (aluno.status) {
      StatusMatricula.ativa => const SituacaoUi(
        texto: 'Matrícula ativa',
        positiva: true,
      ),
      StatusMatricula.trancada => const SituacaoUi(
        texto: 'Matrícula trancada',
        positiva: false,
      ),
      StatusMatricula.concluida => const SituacaoUi(
        texto: 'Curso concluído',
        positiva: true,
      ),
    },
    cr: FormatoData.duasCasas(aluno.cr),
    periodo: '${aluno.periodo}º',
    integralizacao: '${aluno.integralizacaoPercentual}%',
    integralizacaoPercentual: aluno.integralizacaoPercentual,
    faltam:
        'Faltam ${aluno.horasObrigatoriasFaltam} h obrigatórias e '
        '${aluno.horasOptativasFaltam} h optativas.',
  );
}

@riverpod
Future<MeusDadosUi> meusDadosViewModel(Ref ref) async {
  final aluno = await ref.watch(alunoProvider.future);
  return MeusDadosUi(
    matricula: aluno.matricula,
    curso: aluno.curso,
    nivel: aluno.nivel,
    situacao: switch (aluno.status) {
      StatusMatricula.ativa => const SituacaoUi(texto: 'Ativo', positiva: true),
      StatusMatricula.trancada => const SituacaoUi(
        texto: 'Trancado',
        positiva: false,
      ),
      StatusMatricula.concluida => const SituacaoUi(
        texto: 'Concluído',
        positiva: true,
      ),
    },
    entrada: aluno.entrada,
    email: aluno.email,
    telefone: aluno.telefone,
  );
}
