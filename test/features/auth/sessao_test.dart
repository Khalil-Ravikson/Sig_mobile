import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/app_router.dart';
import 'package:siguema_mobile/features/auth/domain/resultado_login.dart';
import 'package:siguema_mobile/features/auth/domain/sessao.dart';
import 'package:siguema_mobile/features/auth/domain/vinculo.dart';
import 'package:siguema_mobile/features/auth/presentation/sessao_provider.dart';

const _v1 = Vinculo(id: 1, tipo: TipoVinculo.aluno, descricao: 'Graduação');
const _v2 = Vinculo(id: 2, tipo: TipoVinculo.aluno, descricao: 'Pós');

ResultadoLogin _login(List<Vinculo> vinculos) =>
    ResultadoLogin(nome: 'Ana Teste', vinculos: vinculos, tokenTemporario: 't');

void main() {
  group('SessaoNotifier', () {
    late ProviderContainer container;
    SessaoNotifier notifier() => container.read(sessaoProvider.notifier);
    Sessao sessao() => container.read(sessaoProvider);

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('começa vazia', () {
      expect(sessao().logado, isFalse);
    });

    test('um só vínculo já fica escolhido', () {
      notifier().entrou(_login([_v1]));
      expect(sessao().vinculo, _v1);
    });

    test('dois vínculos esperam a escolha', () {
      notifier().entrou(_login([_v1, _v2]));
      expect(sessao().logado, isTrue);
      expect(sessao().vinculoEscolhido, isFalse);
      notifier().escolherVinculo(_v2);
      expect(sessao().vinculo, _v2);
    });

    test('trocar mantém o login e limpa o vínculo', () {
      notifier().entrou(_login([_v1, _v2]));
      notifier().escolherVinculo(_v1);
      notifier().trocarVinculo();
      expect(sessao().logado, isTrue);
      expect(sessao().vinculoEscolhido, isFalse);
    });

    test('sair limpa tudo', () {
      notifier().entrou(_login([_v1]));
      notifier().sair();
      expect(sessao().logado, isFalse);
    });
  });

  group('redirecionarPorSessao', () {
    final semLogin = Sessao.vazia;
    final semVinculo = Sessao(login: _login([_v1, _v2]));
    final completa = Sessao(login: _login([_v1]), vinculo: _v1);

    test('sem login manda para o login', () {
      expect(redirecionarPorSessao(semLogin, Rotas.home), Rotas.login);
      expect(redirecionarPorSessao(semLogin, Rotas.vinculo), Rotas.login);
      expect(redirecionarPorSessao(semLogin, Rotas.login), isNull);
    });

    test('logada sem vínculo manda para a escolha', () {
      expect(redirecionarPorSessao(semVinculo, Rotas.login), Rotas.vinculo);
      expect(redirecionarPorSessao(semVinculo, Rotas.home), Rotas.vinculo);
      expect(redirecionarPorSessao(semVinculo, Rotas.vinculo), isNull);
    });

    test('com vínculo manda para a home', () {
      expect(redirecionarPorSessao(completa, Rotas.login), Rotas.home);
      expect(redirecionarPorSessao(completa, Rotas.vinculo), Rotas.home);
      expect(redirecionarPorSessao(completa, Rotas.home), isNull);
    });
  });
}
