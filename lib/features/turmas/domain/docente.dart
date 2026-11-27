import 'package:freezed_annotation/freezed_annotation.dart';

part 'docente.freezed.dart';

@freezed
abstract class Docente with _$Docente {
  const factory Docente({required String nome, required String email}) =
      _Docente;
}
