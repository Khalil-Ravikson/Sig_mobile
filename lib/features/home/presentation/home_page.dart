import 'package:flutter/material.dart';

/// Tela inicial vazia. Será substituída pelo fluxo de login e vínculo.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('SIGUEMA')));
  }
}
