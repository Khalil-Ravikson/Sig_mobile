import 'package:flutter_riverpod/misc.dart' show Override;

import 'core/mock/mock_providers.dart';
import 'features/ajuda/data/json_ajuda_repository.dart';
import 'features/ajuda/presentation/ajuda_view_model.dart';
import 'features/aluno/data/json_aluno_repository.dart';
import 'features/aluno/presentation/aluno_providers.dart';
import 'features/auth/data/json_auth_repository.dart';
import 'features/auth/presentation/auth_providers.dart';
import 'features/documentos/data/json_documentos_repository.dart';
import 'features/documentos/presentation/documentos_providers.dart';
import 'features/turmas/data/json_frequencia_repository.dart';
import 'features/turmas/data/json_semestre_repository.dart';
import 'features/turmas/data/json_turma_repository.dart';
import 'features/turmas/presentation/resumo_semestre_provider.dart';
import 'features/turmas/presentation/turma_providers.dart';

/// Dia fixo do alpha: os JSON têm datas fixas (Figma: quarta, 25/11/2026).
DateTime relogioDoAlpha() => DateTime(2026, 11, 25);

/// Troca as implementações reais pelas que leem `assets/mock/*.json`.
/// Quando a API existir, o app deixa de usar esta lista.
List<Override> alphaOverrides() => [
  authRepositoryProvider.overrideWith(
    (ref) => JsonAuthRepository(ref.watch(fonteJsonProvider)),
  ),
  semestreRepositoryProvider.overrideWith(
    (ref) => JsonSemestreRepository(ref.watch(fonteJsonProvider)),
  ),
  turmaRepositoryProvider.overrideWith(
    (ref) => JsonTurmaRepository(ref.watch(fonteJsonProvider)),
  ),
  frequenciaRepositoryProvider.overrideWith(
    (ref) => JsonFrequenciaRepository(ref.watch(fonteJsonProvider)),
  ),
  documentosRepositoryProvider.overrideWith(
    (ref) => JsonDocumentosRepository(ref.watch(fonteJsonProvider)),
  ),
  alunoRepositoryProvider.overrideWith(
    (ref) => JsonAlunoRepository(ref.watch(fonteJsonProvider)),
  ),
  ajudaRepositoryProvider.overrideWith(
    (ref) => JsonAjudaRepository(ref.watch(fonteJsonProvider)),
  ),
  relogioProvider.overrideWithValue(relogioDoAlpha),
];
