import 'package:siguema_mobile/features/auth/domain/biometria.dart';
import 'package:siguema_mobile/features/auth/domain/perfil_local.dart';

/// Biometria de mentira: devolve os resultados na ordem em que foram dados.
class FakeBiometria implements Biometria {
  FakeBiometria({
    this.estaDisponivel = true,
    List<ResultadoBiometria> resultados = const [ResultadoBiometria.sucesso],
  }) : _resultados = List.of(resultados);

  bool estaDisponivel;
  final List<ResultadoBiometria> _resultados;
  int chamadas = 0;

  @override
  Future<bool> disponivel() async => estaDisponivel;

  @override
  Future<ResultadoBiometria> autenticar({required String motivo}) async {
    chamadas++;
    return _resultados.length > 1 ? _resultados.removeAt(0) : _resultados.first;
  }
}

/// PerfilLocalStore em memória.
class FakePerfilLocalStore implements PerfilLocalStore {
  FakePerfilLocalStore([this.perfil]);

  PerfilLocal? perfil;

  @override
  Future<PerfilLocal?> ler() async => perfil;

  @override
  Future<void> salvar(PerfilLocal novo) async => perfil = novo;

  @override
  Future<void> apagar() async => perfil = null;
}
