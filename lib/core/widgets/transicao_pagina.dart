import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../theme/motion.dart';

/// Transição própria das páginas que abrem por cima das abas: fade + leve
/// subida. Com "Reduzir animações", só uma troca curta de opacidade.
CustomTransitionPage<T> paginaSuave<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: Motion.suave,
    reverseTransitionDuration: Motion.padrao,
    transitionsBuilder: (context, animacao, secundaria, filho) {
      final entrada = CurvedAnimation(
        parent: animacao,
        curve: Motion.entrada,
        reverseCurve: Motion.saida,
      );
      if (Motion.reduzir(context)) {
        // Só um fade curto: termina em ~150 ms dos 400 ms da página.
        final curto = CurvedAnimation(
          parent: animacao,
          curve: const Interval(0, 0.4),
        );
        return FadeTransition(opacity: curto, child: filho);
      }
      return FadeTransition(
        opacity: entrada,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(entrada),
          child: filho,
        ),
      );
    },
  );
}
