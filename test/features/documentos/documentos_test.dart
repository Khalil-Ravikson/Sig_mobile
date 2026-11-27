import 'dart:convert';
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/core/config/sem_novas_tentativas.dart';
import 'package:siguema_mobile/core/error/app_error.dart';
import 'package:siguema_mobile/core/error/result.dart';
import 'package:siguema_mobile/core/mock/fonte_json.dart';
import 'package:siguema_mobile/core/theme/app_theme.dart';
import 'package:siguema_mobile/features/documentos/data/json_documentos_repository.dart';
import 'package:siguema_mobile/features/documentos/domain/documento.dart';
import 'package:siguema_mobile/features/documentos/presentation/documentos_page.dart';
import 'package:siguema_mobile/features/documentos/presentation/documentos_view_model.dart';

import '../../support/app_alpha_de_teste.dart';
import '../../support/arquivos_bundle.dart';

class _BundleComTexto extends ArquivosBundle {
  _BundleComTexto(this.texto);

  final String texto;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(texto)));
}

ProviderContainer _container() {
  final container = ProviderContainer(
    retry: semNovasTentativas,
    overrides: overridesDoAlpha(),
  );
  addTearDown(container.dispose);
  return container;
}

/// Como a tela faz: mantém a busca e a lista vivas (são autoDispose).
ProviderContainer _containerConectado() {
  final container = _container();
  container
    ..listen(consultaDocumentosProvider, (_, _) {})
    ..listen(documentosVisiveisProvider, (_, _) {});
  return container;
}

Future<ProviderContainer> _abrirPagina(WidgetTester tester) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = _container();
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.claro(),
        home: const Scaffold(body: DocumentosPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  group('JsonDocumentosRepository', () {
    test('lê os 5 documentos do JSON', () async {
      final repositorio = JsonDocumentosRepository(
        FonteJson(bundle: ArquivosBundle(), latencia: FonteJson.semLatencia),
      );
      final docs =
          ((await repositorio.carregarDocumentos()) as Sucesso<List<Documento>>)
              .dado;
      expect(docs, hasLength(5));
      expect(docs.first.titulo, 'Comprovante de matrícula');
      expect(docs.first.grupo, GrupoDocumento.maisUsados);
      expect(docs.first.estado, EstadoDocumento.disponivel);
      expect(docs.last.tipo, TipoDocumento.doc);
      expect(docs.last.estado, EstadoDocumento.sobPedido);
    });

    test('valores desconhecidos caem no caso cauteloso', () async {
      final repositorio = JsonDocumentosRepository(
        FonteJson(
          bundle: _BundleComTexto(
            jsonEncode({
              'itens': [
                {
                  'id': 'x',
                  'titulo': 'Novo',
                  'subtitulo': '',
                  'tipo': 'zip',
                  'grupo': 'outro',
                  'estado': 'talvez',
                },
              ],
            }),
          ),
          latencia: FonteJson.semLatencia,
        ),
      );
      final d =
          ((await repositorio.carregarDocumentos()) as Sucesso<List<Documento>>)
              .dado
              .single;
      expect(d.tipo, TipoDocumento.pdf);
      expect(d.grupo, GrupoDocumento.declaracoes);
      expect(d.estado, EstadoDocumento.sobPedido);
    });

    test('JSON quebrado vira Falha, nunca exceção', () async {
      final repositorio = JsonDocumentosRepository(
        FonteJson(
          bundle: _BundleComTexto('{ quebrado'),
          latencia: FonteJson.semLatencia,
        ),
      );
      final r = await repositorio.carregarDocumentos();
      expect((r as Falha).erro, isA<ErroDesconhecido>());
    });
  });

  group('busca (view model)', () {
    test('sem busca, mostra os dois grupos', () async {
      final ui = await _container().read(documentosVisiveisProvider.future);
      expect(ui.grupos.map((g) => g.titulo), [
        'Mais usados',
        'Declarações e atestados',
      ]);
      expect(ui.grupos.first.itens, hasLength(3));
      expect(ui.grupos.last.itens, hasLength(2));
    });

    test('"Baixar" só nos mais usados disponíveis', () async {
      final ui = await _container().read(documentosVisiveisProvider.future);
      expect(ui.grupos.first.itens.every((d) => d.comBotaoBaixar), isTrue);
      expect(ui.grupos.last.itens.any((d) => d.comBotaoBaixar), isFalse);
      expect(ui.grupos.last.itens.last.tipo, 'DOC');
    });

    test('filtra sem ligar para acento nem maiúscula', () async {
      final container = _containerConectado();
      await container.read(documentosVisiveisProvider.future);
      container.read(consultaDocumentosProvider.notifier).digitar('MATRICULA');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      final ui = await container.read(documentosVisiveisProvider.future);
      expect(ui.grupos, hasLength(1));
      expect(ui.grupos.single.itens.single.titulo, 'Comprovante de matrícula');
    });

    test('busca no subtítulo também e esconde grupos vazios', () async {
      final container = _containerConectado();
      await container.read(documentosVisiveisProvider.future);
      container.read(consultaDocumentosProvider.notifier).digitar('secretaria');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      final ui = await container.read(documentosVisiveisProvider.future);
      expect(ui.grupos.single.titulo, 'Declarações e atestados');
      expect(ui.grupos.single.itens.single.titulo, 'Atestado de frequência');
    });

    test('sem resultado: lista vazia e a consulta guardada', () async {
      final container = _containerConectado();
      await container.read(documentosVisiveisProvider.future);
      container.read(consultaDocumentosProvider.notifier).digitar('xyz');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      final ui = await container.read(documentosVisiveisProvider.future);
      expect(ui.semResultado, isTrue);
      expect(ui.consulta, 'xyz');
    });

    test('a consulta só vale 300 ms depois da última tecla', () {
      fakeAsync((async) {
        final container = ProviderContainer(
          retry: semNovasTentativas,
          overrides: overridesDoAlpha(),
        );
        final notifier = container.read(consultaDocumentosProvider.notifier);
        container.listen(consultaDocumentosProvider, (_, _) {});

        notifier.digitar('m');
        async.elapse(const Duration(milliseconds: 200));
        notifier.digitar('ma');
        async.elapse(const Duration(milliseconds: 200));
        expect(container.read(consultaDocumentosProvider), '');
        async.elapse(const Duration(milliseconds: 101));
        expect(container.read(consultaDocumentosProvider), 'ma');
        container.dispose();
      });
    });

    test('limpar vale na hora e cancela a digitação pendente', () {
      fakeAsync((async) {
        final container = ProviderContainer(
          retry: semNovasTentativas,
          overrides: overridesDoAlpha(),
        );
        final notifier = container.read(consultaDocumentosProvider.notifier);
        container.listen(consultaDocumentosProvider, (_, _) {});
        notifier.digitar('abc');
        async.elapse(const Duration(milliseconds: 350));
        expect(container.read(consultaDocumentosProvider), 'abc');

        notifier.digitar('abcd');
        notifier.limpar();
        expect(container.read(consultaDocumentosProvider), '');
        async.elapse(const Duration(seconds: 1));
        expect(container.read(consultaDocumentosProvider), '');
        container.dispose();
      });
    });
  });

  group('tela', () {
    testWidgets('mostra os grupos, o botão e os selos', (tester) async {
      await _abrirPagina(tester);
      expect(find.text('Documentos'), findsOneWidget);
      expect(find.text('Comprovantes e declarações em PDF'), findsOneWidget);
      expect(find.text('Mais usados'), findsOneWidget);
      expect(find.text('Comprovante de matrícula'), findsOneWidget);
      expect(find.text('Semestre 2026.2'), findsOneWidget);
      expect(find.text('Baixar'), findsNWidgets(3));
      expect(find.text('Declarações e atestados'), findsOneWidget);
      expect(find.text('Disponível'), findsOneWidget);
      expect(find.text('Sob pedido'), findsOneWidget);
      expect(find.text('PDF'), findsNWidgets(4));
      expect(find.text('DOC'), findsOneWidget);
    });

    testWidgets('digitar filtra só depois de 300 ms', (tester) async {
      await _abrirPagina(tester);
      await tester.enterText(find.byType(TextField), 'histór');
      await tester.pump(const Duration(milliseconds: 200));
      // Ainda não aplicou: a lista inteira continua lá.
      expect(find.text('Relatório de notas'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('Histórico escolar'), findsOneWidget);
      expect(find.text('Relatório de notas'), findsNothing);
      expect(find.text('Declarações e atestados'), findsNothing);
    });

    testWidgets('sem resultado mostra a mensagem com o termo', (tester) async {
      await _abrirPagina(tester);
      await tester.enterText(find.byType(TextField), 'passaporte');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(
        find.text('Nenhum documento encontrado para "passaporte".'),
        findsOneWidget,
      );
      expect(find.text('Mais usados'), findsNothing);
    });

    testWidgets('limpar a busca traz a lista de volta na hora', (tester) async {
      await _abrirPagina(tester);
      await tester.enterText(find.byType(TextField), 'passaporte');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      await tester.tap(find.bySemanticsLabel('Limpar busca'));
      await tester.pumpAndSettle();
      expect(find.text('Mais usados'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    });

    testWidgets('tocar num documento explica que o PDF não é real', (
      tester,
    ) async {
      await _abrirPagina(tester);
      await tester.tap(find.text('Histórico escolar'));
      await tester.pump();
      expect(find.textContaining('não é gerado de verdade'), findsOneWidget);
    });

    testWidgets('tocar num documento sob pedido fala da secretaria', (
      tester,
    ) async {
      await _abrirPagina(tester);
      await tester.ensureVisible(find.text('Atestado de frequência'));
      await tester.tap(find.text('Atestado de frequência'));
      await tester.pump();
      expect(find.textContaining('retirado na secretaria'), findsOneWidget);
    });
  });
}
