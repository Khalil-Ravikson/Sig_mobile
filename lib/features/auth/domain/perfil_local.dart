import 'cpf.dart';

/// O que o app lembra deste aparelho para a tela de "quem volta".
/// Só dados que não identificam a pessoa por si sós: CPF mascarado e iniciais.
/// Nunca guarda senha, CPF inteiro nem token (o token fica em `TokenStore`).
class PerfilLocal {
  const PerfilLocal({
    required this.cpfMascarado,
    required this.iniciais,
    this.biometriaAtiva = false,
    this.conviteRecusado = false,
  });

  /// Monta a partir do login: o CPF inteiro é descartado aqui.
  factory PerfilLocal.de({required String nome, required String cpf}) =>
      PerfilLocal(cpfMascarado: mascararCpf(cpf), iniciais: iniciaisDe(nome));

  factory PerfilLocal.fromJson(Map<String, Object?> json) => PerfilLocal(
    cpfMascarado: json['cpfMascarado']! as String,
    iniciais: json['iniciais']! as String,
    biometriaAtiva: json['biometriaAtiva'] == true,
    conviteRecusado: json['conviteRecusado'] == true,
  );

  final String cpfMascarado;
  final String iniciais;
  final bool biometriaAtiva;
  final bool conviteRecusado;

  PerfilLocal copyWith({bool? biometriaAtiva, bool? conviteRecusado}) =>
      PerfilLocal(
        cpfMascarado: cpfMascarado,
        iniciais: iniciais,
        biometriaAtiva: biometriaAtiva ?? this.biometriaAtiva,
        conviteRecusado: conviteRecusado ?? this.conviteRecusado,
      );

  Map<String, Object?> toJson() => {
    'cpfMascarado': cpfMascarado,
    'iniciais': iniciais,
    'biometriaAtiva': biometriaAtiva,
    'conviteRecusado': conviteRecusado,
  };
}

/// `12345678901` → `***.456.789-**`. Só mostra o miolo do CPF.
String mascararCpf(String cpf) {
  final d = somenteDigitos(cpf);
  if (d.length != 11) return '***.***.***-**';
  return '***.${d.substring(3, 6)}.${d.substring(6, 9)}-**';
}

/// `Ana Lúcia Souza` → `AS` (primeira e última letras dos nomes).
String iniciaisDe(String nome) {
  final partes = nome.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (partes.isEmpty) return '?';
  final primeira = partes.first;
  if (partes.length == 1) return primeira[0].toUpperCase();
  return (primeira[0] + partes.last[0]).toUpperCase();
}

/// Guarda o [PerfilLocal] no aparelho.
abstract interface class PerfilLocalStore {
  Future<PerfilLocal?> ler();
  Future<void> salvar(PerfilLocal perfil);
  Future<void> apagar();
}
