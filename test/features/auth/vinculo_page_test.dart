import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/auth/domain/resultado_login.dart';
import 'package:siguema_mobile/features/auth/domain/vinculo.dart';
import 'package:siguema_mobile/features/auth/presentation/vinculo_page.dart';

const _dois = ResultadoLogin(
  nome: 'Ana Teste da Silva',
  tokenTemporario: 'tmp',
  vinculos: [
    Vinculo(
      id: 1,
      tipo: TipoVinculo.professor,
      descricao: 'Dep. de Engenharia de Computação',
    ),
    Vinculo(id: 2, tipo: TipoVinculo.servidor, descricao: 'Coordenação de TI'),
  ],
);

Future<void> _abrir(
  WidgetTester tester,
  ResultadoLogin r, {
  ValueChanged<Vinculo>? onEscolher,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.claro(),
      home: VinculoPage(resultado: r, onEscolher: onEscolher ?? (_) {}),
    ),
  );
}

void main() {
  testWidgets('saúda pelo primeiro nome e lista todos os vínculos', (
    tester,
  ) async {
    await _abrir(tester, _dois);
    expect(find.text('Olá, Ana'), findsOneWidget);
    expect(find.text('Portal do Docente'), findsOneWidget);
    expect(find.text('Portal do Servidor'), findsOneWidget);
    expect(find.text('Coordenação de TI'), findsOneWidget);
  });

  testWidgets('tocar num cartão escolhe aquele vínculo', (tester) async {
    Vinculo? escolhido;
    await _abrir(tester, _dois, onEscolher: (v) => escolhido = v);
    await tester.tap(find.text('Portal do Servidor'));
    await tester.pump();
    expect(escolhido?.id, 2);
  });

  testWidgets('sem vínculos mostra orientação', (tester) async {
    await _abrir(
      tester,
      const ResultadoLogin(nome: 'Ana', vinculos: [], tokenTemporario: 't'),
    );
    expect(find.textContaining('Nenhum vínculo ativo'), findsOneWidget);
  });
}
