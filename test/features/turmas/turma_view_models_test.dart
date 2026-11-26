import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/config/sem_novas_tentativas.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';
import 'package:siguema_mobile/features/turmas/data/json_frequencia_repository.dart';
import 'package:siguema_mobile/features/turmas/domain/frequencia_repository.dart';
import 'package:siguema_mobile/features/turmas/domain/frequencia_resumo.dart';
import 'package:siguema_mobile/features/turmas/domain/pagina_aulas.dart';
import 'package:siguema_mobile/features/turmas/presentation/frequencia_view_model.dart';
import 'package:siguema_mobile/features/turmas/presentation/turma_providers.dart';
import 'package:siguema_mobile/features/turmas/presentation/turma_virtual_view_model.dart';

import '../../support/app_alpha_de_teste.dart';
import '../../support/arquivos_bundle.dart';

/// Repositório de frequência que pode falhar nas páginas seguintes.
class _FrequenciaQueFalha implements FrequenciaRepository {
  _FrequenciaQueFalha(this._real);

  final FrequenciaRepository _real;
  bool falhar = false;
  int paginasPedidas = 0;

  @override
  Future<Result<FrequenciaResumo>> carregarResumo(String turmaId) =>
      _real.carregarResumo(turmaId);

  @override
  Future<Result<PaginaAulas>> carregarAulas(
    String turmaId, {
    int pagina = 0,
    int tamanho = 20,
  }) {
    paginasPedidas++;
    if (falhar && pagina > 0) {
      return Future.value(const Falha<PaginaAulas>(SemConexao()));
    }
    return _real.carregarAulas(turmaId, pagina: pagina, tamanho: tamanho);
  }
}

ProviderContainer _container({FrequenciaRepository? frequencia}) {
  final container = ProviderContainer(
    retry: semNovasTentativas,
    overrides: <Override>[
      if (frequencia == null)
        ...overridesDoAlpha()
      else ...[
        ...overridesDoAlphaSemFrequencia(),
        frequenciaRepositoryProvider.overrideWithValue(frequencia),
      ],
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('TurmaVirtualViewModel', () {
    test('monta o resumo com frequência, notas, avaliação e docente', () async {
      final turma = await _container().read(
        turmaVirtualViewModelProvider('t01').future,
      );
      expect(turma.disciplina, 'Análise e Processamento de Sinais');
      expect(turma.semestre, '2026.2');
      expect(turma.subtitulo, 'Turma 01 · Seg e qua · 3º e 4º horário');
      expect(turma.frequenciaPercentual, 94);
      expect(turma.textoFrequencia, '2 faltas em 32 aulas');
      expect(turma.limiteFaltas, 8);
      expect(turma.dentroDoLimite, isTrue);
      expect(turma.celulasDeNotas.map((c) => '${c.rotulo}=${c.valor}'), [
        'N1=5,0',
        'N2=7,5',
        'N3=—',
        'Média=6,3',
      ]);
      expect(turma.celulasDeNotas[2].lancada, isFalse);
      expect(turma.celulasDeNotas.last.destaque, isTrue);
      expect(turma.proxima!.titulo, 'Avaliação · Análise de Sinais');
      expect(turma.proxima!.dia, '03');
      expect(turma.proxima!.mes, 'DEZ');
      expect(turma.proxima!.detalhe, '03/12 · 08h00 · em 8 dias');
      expect(turma.docente.nome, 'Helena Exemplo Prado');
      expect(turma.docente.iniciais, 'HP');
    });

    test('detalhes de notas incluem 2ª chamada e prova final', () async {
      final turma = await _container().read(
        turmaVirtualViewModelProvider('t01').future,
      );
      expect(turma.detalhesDeNotas.map((d) => d.$1), [
        'Nota 1',
        'Nota 2',
        'Nota 3',
        '2ª chamada',
        'Prova final',
        'Média',
      ]);
      expect(turma.detalhesDeNotas.last.$2, '6,3');
    });

    test('turma sem aulas nem avaliação', () async {
      final turma = await _container().read(
        turmaVirtualViewModelProvider('t03').future,
      );
      expect(turma.temAulas, isFalse);
      expect(turma.textoFrequencia, 'Ainda sem aulas registradas');
      expect(turma.proxima, isNull);
      expect(turma.subtitulo, 'Turma 01 · Sem horário fixo');
    });

    test('id que não está no semestre dá NaoEncontrado', () async {
      await expectLater(
        _container().read(turmaVirtualViewModelProvider('zzz').future),
        throwsA(isA<NaoEncontrado>()),
      );
    });
  });

  group('FrequenciaViewModel', () {
    test('começa com 20 dias e o resumo inteiro', () async {
      final ui = await _container().read(
        frequenciaViewModelProvider('t01').future,
      );
      expect(ui.dias, hasLength(tamanhoPaginaFrequencia));
      expect(ui.temMais, isTrue);
      expect(ui.resumo.totalAulas, 32);
      expect(ui.resumo.pontos, hasLength(32));
    });

    test('carregarMais junta a segunda página e para', () async {
      final container = _container();
      final provider = frequenciaViewModelProvider('t01');
      await container.read(provider.future);

      await container.read(provider.notifier).carregarMais();
      final ui = container.read(provider).requireValue;
      expect(ui.dias, hasLength(32));
      expect(ui.temMais, isFalse);
      expect(ui.carregandoMais, isFalse);

      // Sem mais nada: chamar de novo não muda nada.
      await container.read(provider.notifier).carregarMais();
      expect(container.read(provider).requireValue.dias, hasLength(32));
    });

    test('chamadas repetidas enquanto carrega pedem uma só página', () async {
      final falso = _FrequenciaQueFalha(
        JsonFrequenciaRepository(
          FonteJson(bundle: ArquivosBundle(), latencia: FonteJson.semLatencia),
        ),
      );
      final container = _container(frequencia: falso);
      final provider = frequenciaViewModelProvider('t01');
      await container.read(provider.future);
      expect(falso.paginasPedidas, 1);

      final notifier = container.read(provider.notifier);
      await Future.wait([
        notifier.carregarMais(),
        notifier.carregarMais(),
        notifier.carregarMais(),
      ]);
      expect(falso.paginasPedidas, 2);
      expect(container.read(provider).requireValue.dias, hasLength(32));
    });

    test('falha ao carregar mais mantém o que já tinha e avisa', () async {
      final falso = _FrequenciaQueFalha(
        JsonFrequenciaRepository(
          FonteJson(bundle: ArquivosBundle(), latencia: FonteJson.semLatencia),
        ),
      )..falhar = true;
      final container = _container(frequencia: falso);
      final provider = frequenciaViewModelProvider('t01');
      await container.read(provider.future);

      await container.read(provider.notifier).carregarMais();
      var ui = container.read(provider).requireValue;
      expect(ui.dias, hasLength(20));
      expect(ui.temMais, isTrue);
      expect(ui.falhouAoCarregarMais, isTrue);
      expect(ui.carregandoMais, isFalse);

      // Tentar de novo, agora com sucesso.
      falso.falhar = false;
      await container.read(provider.notifier).carregarMais();
      ui = container.read(provider).requireValue;
      expect(ui.dias, hasLength(32));
      expect(ui.falhouAoCarregarMais, isFalse);
    });

    test('turma desconhecida vira erro', () async {
      await expectLater(
        _container().read(frequenciaViewModelProvider('zzz').future),
        throwsA(isA<NaoEncontrado>()),
      );
    });
  });

  group('agruparPorMes', () {
    test('agrupa em ordem, sem misturar meses', () async {
      final ui = await _container().read(
        frequenciaViewModelProvider('t01').future,
      );
      final grupos = ui.grupos;
      expect(grupos.first.titulo, 'Novembro');
      expect(grupos.map((g) => g.titulo).toSet(), hasLength(grupos.length));
      expect(
        grupos.fold<int>(0, (soma, g) => soma + g.dias.length),
        ui.dias.length,
      );
    });

    test('depois da segunda página o mês cortado se junta', () async {
      final container = _container();
      final provider = frequenciaViewModelProvider('t01');
      await container.read(provider.future);
      await container.read(provider.notifier).carregarMais();
      final grupos = container.read(provider).requireValue.grupos;
      expect(grupos.map((g) => g.titulo), [
        'Novembro',
        'Outubro',
        'Setembro',
        'Agosto',
      ]);
      expect(grupos.last.dias, hasLength(7));
    });
  });
}
