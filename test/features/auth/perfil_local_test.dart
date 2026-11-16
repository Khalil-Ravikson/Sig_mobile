import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:siguema_mobile/features/auth/data/biometria_local_auth.dart';
import 'package:siguema_mobile/features/auth/domain/biometria.dart';
import 'package:siguema_mobile/features/auth/domain/perfil_local.dart';

void main() {
  group('mascararCpf', () {
    test('mostra só o miolo', () {
      expect(mascararCpf('12345678901'), '***.456.789-**');
      expect(mascararCpf('123.456.789-01'), '***.456.789-**');
    });

    test('CPF com tamanho errado não vaza nada', () {
      expect(mascararCpf('123'), '***.***.***-**');
    });
  });

  group('iniciaisDe', () {
    test('primeira e última letras dos nomes', () {
      expect(iniciaisDe('Ana Lúcia Souza'), 'AS');
      expect(iniciaisDe('  maria   teste '), 'MT');
    });

    test('nome com uma palavra e nome vazio', () {
      expect(iniciaisDe('Maria'), 'M');
      expect(iniciaisDe('   '), '?');
    });
  });

  group('PerfilLocal', () {
    test('monta pelo login sem guardar o CPF inteiro', () {
      final perfil = PerfilLocal.de(nome: 'Maria Teste', cpf: '00000000001');
      final json = jsonEncode(perfil.toJson());

      expect(perfil.cpfMascarado, '***.000.000-**');
      expect(perfil.iniciais, 'MT');
      expect(json.contains('00000000001'), isFalse);
      expect(perfil.biometriaAtiva, isFalse);
    });

    test('vai e volta pelo JSON', () {
      const perfil = PerfilLocal(
        cpfMascarado: '***.456.789-**',
        iniciais: 'AL',
        biometriaAtiva: true,
        conviteRecusado: true,
      );
      final volta = PerfilLocal.fromJson(
        jsonDecode(jsonEncode(perfil.toJson())) as Map<String, Object?>,
      );

      expect(volta.cpfMascarado, perfil.cpfMascarado);
      expect(volta.iniciais, 'AL');
      expect(volta.biometriaAtiva, isTrue);
      expect(volta.conviteRecusado, isTrue);
    });
  });

  group('BiometriaLocalAuth.mapearCodigo', () {
    test('fechar a janela é cancelamento, não erro', () {
      for (final c in [
        LocalAuthExceptionCode.userCanceled,
        LocalAuthExceptionCode.systemCanceled,
        LocalAuthExceptionCode.timeout,
      ]) {
        expect(
          BiometriaLocalAuth.mapearCodigo(c),
          ResultadoBiometria.cancelada,
        );
      }
    });

    test('bloqueio do sistema vira bloqueada', () {
      expect(
        BiometriaLocalAuth.mapearCodigo(
          LocalAuthExceptionCode.biometricLockout,
        ),
        ResultadoBiometria.bloqueada,
      );
      expect(
        BiometriaLocalAuth.mapearCodigo(
          LocalAuthExceptionCode.temporaryLockout,
        ),
        ResultadoBiometria.bloqueada,
      );
    });

    test('sem sensor ou sem digital cadastrada vira indisponível', () {
      expect(
        BiometriaLocalAuth.mapearCodigo(
          LocalAuthExceptionCode.noBiometricsEnrolled,
        ),
        ResultadoBiometria.indisponivel,
      );
      expect(
        BiometriaLocalAuth.mapearCodigo(
          LocalAuthExceptionCode.noBiometricHardware,
        ),
        ResultadoBiometria.indisponivel,
      );
    });
  });
}
