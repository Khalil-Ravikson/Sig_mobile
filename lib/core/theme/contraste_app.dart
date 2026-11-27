import 'package:flutter/widgets.dart';

import 'app_colors.dart';
import 'app_shadows.dart';

/// Diz às telas se o modo de alto contraste está ligado (opção "Alto
/// contraste" do Perfil ou ajuste do sistema).
///
/// A paleta do app já passa de AA (texto secundário 7,7:1 sobre branco, no
/// Figma). O modo de alto contraste vai além: tira os preenchimentos tonais e
/// a sombra suave, e separa cada superfície e controle com uma borda de
/// 1,5 px em marinho (contraste de componente de 3:1 ou mais).
class ContrasteApp extends InheritedWidget {
  const ContrasteApp({super.key, required this.ativo, required super.child});

  final bool ativo;

  static bool deContexto(BuildContext context) {
    final heranca = context.dependOnInheritedWidgetOfExactType<ContrasteApp>();
    return heranca?.ativo ?? MediaQuery.highContrastOf(context);
  }

  @override
  bool updateShouldNotify(ContrasteApp antigo) => antigo.ativo != ativo;
}

/// Atalhos para as telas e os componentes se adaptarem ao contraste.
extension ContrasteNoContexto on BuildContext {
  bool get altoContraste => ContrasteApp.deContexto(this);

  /// Fundo das telas: branco em alto contraste (texto secundário vai a 7,7:1).
  Color get fundoDaTela =>
      altoContraste ? AppColors.branco : AppColors.fundoTela;

  /// Preenchimento tonal (fichas, campos, chips): vira branco; a borda separa.
  Color tonal(Color normal) => altoContraste ? AppColors.branco : normal;

  /// Fio entre linhas de uma lista.
  Color get fio => altoContraste ? AppColors.textoSecundario : AppColors.borda;

  /// Ícones de apoio (setas): mais escuros em alto contraste.
  Color get iconeSuave =>
      altoContraste ? AppColors.textoSecundario : AppColors.textoSuave;

  /// Borda de superfícies e controles (`null` no modo normal).
  BoxBorder? bordaContraste([Color cor = AppColors.marinho]) =>
      altoContraste ? Border.all(color: cor, width: 1.5) : null;

  /// Sombra dos cartões (nenhuma em alto contraste: a borda faz o papel).
  List<BoxShadow> get sombraCartao =>
      altoContraste ? const [] : AppShadows.cartao;
}
