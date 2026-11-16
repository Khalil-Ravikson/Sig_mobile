import 'package:freezed_annotation/freezed_annotation.dart';

import 'vinculo.dart';

part 'resultado_login.freezed.dart';

@freezed
abstract class ResultadoLogin with _$ResultadoLogin {
  const factory ResultadoLogin({
    required String nome,
    required List<Vinculo> vinculos,
    required String tokenTemporario,
  }) = _ResultadoLogin;
}
