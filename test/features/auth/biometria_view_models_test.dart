import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siguema_mobile/features/auth/domain/biometria.dart';
import 'package:siguema_mobile/features/auth/domain/perfil_local.dart';
import 'package:siguema_mobile/features/auth/presentation/auth_providers.dart';
import 'package:siguema_mobile/features/auth/presentation/biometria_view_model.dart';
import 'package:siguema_mobile/features/auth/presentation/convite_biometria_view_model.dart';

import '../../support/fakes_biometria.dart';

const _perfil = PerfilLocal(cpfMascarado: '***.456.789-**', iniciais: 'AL');

ProviderContainer _container(FakeBiometria bio, [FakePerfilLocalStore? store]) {
  final c = ProviderContainer(
    overrides: [
      biometriaProvider.overrideWithValue(bio),
      perfilLocalStoreProvider.overrideWithValue(
        store ?? FakePerfilLocalStore(),
      ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('BiometriaViewModel', () {
    Future<FaseBiometria> rodar(ResultadoBiometria r) async {
      final c = _container(FakeBiometria(resultados: [r]));
      c.listen(biometriaViewModelProvider, (_, _) {});
      await c.read(biometriaViewModelProvider.notifier).autenticar();
      return c.read(biometriaViewModelProvider);
    }

    test('começa no inicial', () {
      final c = _container(FakeBiometria());
      expect(c.read(biometriaViewModelProvider), FaseBiometria.inicial);
    });

    test('cada resultado vira a fase certa', () async {
      expect(await rodar(ResultadoBiometria.sucesso), FaseBiometria.sucesso);
      expect(
        await rodar(ResultadoBiometria.naoReconhecida),
        FaseBiometria.naoReconhecida,
      );
      expect(
        await rodar(ResultadoBiometria.bloqueada),
        FaseBiometria.bloqueada,
      );
      expect(
        await rodar(ResultadoBiometria.indisponivel),
        FaseBiometria.indisponivel,
      );
    });

    test('fechar a janela do sistema volta ao inicial, sem erro', () async {
      expect(await rodar(ResultadoBiometria.cancelada), FaseBiometria.inicial);
    });

    test('depois de falhar dá para tentar de novo e entrar', () async {
      final bio = FakeBiometria(
        resultados: [
          ResultadoBiometria.naoReconhecida,
          ResultadoBiometria.sucesso,
        ],
      );
      final c = _container(bio);
      c.listen(biometriaViewModelProvider, (_, _) {});
      final vm = c.read(biometriaViewModelProvider.notifier);

      await vm.autenticar();
      expect(c.read(biometriaViewModelProvider), FaseBiometria.naoReconhecida);
      await vm.autenticar();
      expect(c.read(biometriaViewModelProvider), FaseBiometria.sucesso);
      expect(bio.chamadas, 2);
    });
  });

  group('ConviteBiometriaViewModel', () {
    Future<bool> deve(FakeBiometria bio, [PerfilLocal? salvo]) {
      final c = _container(bio, FakePerfilLocalStore(salvo));
      return c.read(conviteBiometriaViewModelProvider.notifier).deveOferecer();
    }

    test('convida quem tem biometria e ainda não respondeu', () async {
      expect(await deve(FakeBiometria()), isTrue);
    });

    test('não convida sem biometria no aparelho', () async {
      expect(await deve(FakeBiometria(estaDisponivel: false)), isFalse);
    });

    test('não convida quem já ativou nem quem disse agora não', () async {
      expect(
        await deve(FakeBiometria(), _perfil.copyWith(biometriaAtiva: true)),
        isFalse,
      );
      expect(
        await deve(FakeBiometria(), _perfil.copyWith(conviteRecusado: true)),
        isFalse,
      );
    });

    test('ativar confirma com a digital e liga no perfil', () async {
      final store = FakePerfilLocalStore();
      final c = _container(FakeBiometria(), store);
      final ligou = await c
          .read(conviteBiometriaViewModelProvider.notifier)
          .ativar(_perfil);

      expect(ligou, isTrue);
      expect(store.perfil?.biometriaAtiva, isTrue);
    });

    test('se a digital não confirma, não liga', () async {
      final store = FakePerfilLocalStore();
      final c = _container(
        FakeBiometria(resultados: [ResultadoBiometria.naoReconhecida]),
        store,
      );
      final ligou = await c
          .read(conviteBiometriaViewModelProvider.notifier)
          .ativar(_perfil);

      expect(ligou, isFalse);
      expect(store.perfil, isNull);
    });

    test('recusar lembra o agora não e não liga a digital', () async {
      final store = FakePerfilLocalStore();
      final c = _container(FakeBiometria(), store);
      await c.read(conviteBiometriaViewModelProvider.notifier).recusar(_perfil);

      expect(store.perfil?.conviteRecusado, isTrue);
      expect(store.perfil?.biometriaAtiva, isFalse);
    });
  });
}
