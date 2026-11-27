import 'dart:async';

/// Espera [duracao] sem novas chamadas antes de executar a ação (busca
/// enquanto a pessoa digita). Cada `executar` cancela o anterior.
class Debouncer {
  Debouncer({this.duracao = const Duration(milliseconds: 300)});

  final Duration duracao;
  Timer? _timer;

  void executar(void Function() acao) {
    _timer?.cancel();
    _timer = Timer(duracao, acao);
  }

  /// Descarta a ação que estava esperando.
  void cancelar() {
    _timer?.cancel();
    _timer = null;
  }
}
