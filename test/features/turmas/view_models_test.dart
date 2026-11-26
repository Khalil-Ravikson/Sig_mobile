import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/config/sem_novas_tentativas.dart';
import 'package:siguema_mobile/core/mock/mock_providers.dart';
import 'package:siguema_mobile/features/inicio/presentation/inicio_view_model.dart';
import 'package:siguema_mobile/features/turmas/presentation/resumo_semestre_provider.dart';
import 'package:siguema_mobile/features/turmas/presentation/turmas_view_model.dart';

import '../../support/fakes_semestre.dart';

ProviderContainer _container(SemestreRepositoryFalso repositorio) {
  final container = ProviderContainer(
    retry: semNovasTentativas,
    overrides: <Override>[
      semestreRepositoryProvider.overrideWithValue(repositorio),
      relogioProvider.overrideWithValue(relogioDeTeste),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('InicioViewModel', () {
    test(
      'mostra índices e só as provas que ainda vão acontecer, em ordem',
      () async {
        final container = _container(SemestreRepositoryFalso.comDados());
        final inicio = await container.read(inicioViewModelProvider.future);

        expect(inicio.semestre, '2026.2');
        expect(inicio.cr, 7.25);
        expect(inicio.integralizacao, 87);
        expect(inicio.provas.map((p) => p.titulo), [
          'Avaliação · Um',
          'Avaliação · Dois',
        ]);
        expect(inicio.provas.first.dia, '03');
        expect(inicio.provas.first.mes, 'DEZ');
        expect(inicio.provas.first.quando, 'Em 8 dias');
        expect(inicio.provas.last.quando, 'Em 15 dias');
      },
    );

    test('limita a 3 provas', () async {
      final repositorio = SemestreRepositoryFalso.comDados(
        resumoDeTeste(
          avaliacoes: [
            for (var i = 1; i <= 5; i++)
              AvaliacaoDeTeste.em(DateTime(2026, 12, i), 'P$i'),
          ],
        ),
      );
      final inicio = await _container(
        repositorio,
      ).read(inicioViewModelProvider.future);
      expect(inicio.provas, hasLength(3));
    });

    test('sem provas futuras, a lista vem vazia', () async {
      final inicio = await _container(
        SemestreRepositoryFalso.comDados(resumoDeTeste(avaliacoes: [])),
      ).read(inicioViewModelProvider.future);
      expect(inicio.provas, isEmpty);
    });

    test('falha do repositório vira erro de tela', () async {
      final container = _container(SemestreRepositoryFalso.comFalha());
      await expectLater(
        container.read(inicioViewModelProvider.future),
        throwsA(isA<Object>()),
      );
    });
  });

  group('TurmasViewModel', () {
    test('formata frequência, nota e próxima prova', () async {
      final container = _container(SemestreRepositoryFalso.comDados());
      final turmas = await container.read(turmasViewModelProvider.future);

      expect(turmas.semestre, '2026.2');
      expect(turmas.turmas, hasLength(2));
      final primeira = turmas.turmas.first;
      expect(primeira.frequencia, '94%');
      expect(primeira.ultimaNota, '7,5');
      expect(primeira.proximaProva, '03/12');
      final segunda = turmas.turmas.last;
      expect(segunda.ultimaNota, '—');
      expect(segunda.proximaProva, '—');
      expect(segunda.horario, 'Sem horário definido');
    });
  });

  test('Início e Turmas dividem um único carregamento (sem N+1)', () async {
    final repositorio = SemestreRepositoryFalso.comDados();
    final container = _container(repositorio);
    await container.read(inicioViewModelProvider.future);
    await container.read(turmasViewModelProvider.future);
    expect(repositorio.chamadas, 1);
  });
}
