import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/auth/domain/resultado_login.dart';
import 'package:siguema_mobile/features/auth/domain/vinculo.dart';
import 'package:siguema_mobile/features/auth/presentation/sessao_provider.dart';
import 'package:siguema_mobile/features/home/presentation/home_page.dart';

Future<void> _abrir(WidgetTester tester, Vinculo vinculo) async {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  container
      .read(sessaoProvider.notifier)
      .entrou(
        ResultadoLogin(
          nome: 'Lucas Teste Souza',
          vinculos: [vinculo],
          tokenTemporario: 't',
        ),
      );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(theme: AppTheme.claro(), home: const HomePage()),
    ),
  );
}

void main() {
  testWidgets('discente vê hero, próxima aula e turmas', (tester) async {
    await _abrir(
      tester,
      const Vinculo(
        id: 1,
        tipo: TipoVinculo.aluno,
        descricao: 'Engenharia de Computação',
      ),
    );
    expect(find.text('Olá, Lucas'), findsOneWidget);
    expect(find.text('LS'), findsOneWidget);
    expect(
      find.text('Portal do Discente · Engenharia de Computação'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Próxima: Ciência e Tecnologia dos Materiais'),
      findsOneWidget,
    );
    expect(find.text('Turmas'), findsOneWidget);
    expect(find.text('3 no semestre'), findsOneWidget);
  });

  testWidgets('outros vínculos veem o aviso de em breve', (tester) async {
    await _abrir(
      tester,
      const Vinculo(
        id: 4,
        tipo: TipoVinculo.professor,
        descricao: 'Dep. de Matemática',
      ),
    );
    expect(find.text('Olá, Lucas'), findsOneWidget);
    expect(find.text('A Home deste vínculo chega em breve.'), findsOneWidget);
    expect(find.text('Turmas'), findsNothing);
  });
}
