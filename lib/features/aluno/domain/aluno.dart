import 'package:freezed_annotation/freezed_annotation.dart';

part 'aluno.freezed.dart';

enum StatusMatricula { ativa, trancada, concluida }

/// Dados do discente como o app os mostra (Perfil e Meus dados).
@freezed
abstract class Aluno with _$Aluno {
  const factory Aluno({
    required String nome,
    required String iniciais,
    required String matricula,
    required String curso,
    required String nivel,
    required StatusMatricula status,
    required String entrada,
    required int periodo,
    required double cr,
    required int integralizacaoPercentual,
    required int horasObrigatoriasFaltam,
    required int horasOptativasFaltam,
    required String email,
    required String telefone,
  }) = _Aluno;
}
