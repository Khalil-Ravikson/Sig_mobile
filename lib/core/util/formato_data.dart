/// Formatação de datas em português, sem depender de `intl`.
abstract final class FormatoData {
  static const _meses = [
    'JAN',
    'FEV',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OUT',
    'NOV',
    'DEZ',
  ];

  static const _dias = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo',
  ];

  /// `2026-12-03` → `DateTime(2026, 12, 3)`; `null` se vier vazio ou inválido.
  static DateTime? lerData(String? texto) {
    if (texto == null || texto.isEmpty) return null;
    final data = DateTime.tryParse(texto);
    if (data == null) return null;
    return DateTime(data.year, data.month, data.day);
  }

  /// `03`
  static String dia(DateTime data) => data.day.toString().padLeft(2, '0');

  /// `DEZ`
  static String mesAbreviado(DateTime data) => _meses[data.month - 1];

  /// `03/12`
  static String diaMes(DateTime data) =>
      '${dia(data)}/${data.month.toString().padLeft(2, '0')}';

  /// `Quarta, 25/11`
  static String diaSemanaDiaMes(DateTime data) =>
      '${_dias[data.weekday - 1]}, ${diaMes(data)}';

  /// `Hoje`, `Amanhã` ou `Em 8 dias` (datas passadas: `Já passou`).
  static String emDias(DateTime data, DateTime hoje) {
    final dias = diasAte(data, hoje);
    if (dias < 0) return 'Já passou';
    if (dias == 0) return 'Hoje';
    if (dias == 1) return 'Amanhã';
    return 'Em $dias dias';
  }

  /// Dias de calendário entre [hoje] e [data] (negativo se já passou).
  static int diasAte(DateTime data, DateTime hoje) {
    final a = DateTime.utc(data.year, data.month, data.day);
    final b = DateTime.utc(hoje.year, hoje.month, hoje.day);
    return a.difference(b).inDays;
  }

  static const _mesesPorExtenso = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  static const _diasCurtos = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  /// `Setembro`
  static String nomeMes(DateTime data) => _mesesPorExtenso[data.month - 1];

  /// `Qua`
  static String diaSemanaCurto(DateTime data) => _diasCurtos[data.weekday - 1];

  /// `13:10` → `13h10`; `null` ou vazio → `null`.
  static String? hora(String? texto) {
    if (texto == null || texto.isEmpty) return null;
    return texto.replaceFirst(':', 'h');
  }

  /// `Em 15 dias` → `em 15 dias` (para usar no meio de uma frase).
  static String minusculaInicial(String texto) =>
      texto.isEmpty ? texto : texto[0].toLowerCase() + texto.substring(1);

  /// `7,5` (vírgula decimal), `—` para `null`.
  static String nota(double? valor) {
    if (valor == null) return '—';
    final texto = valor == valor.roundToDouble()
        ? valor.toStringAsFixed(0)
        : valor.toString();
    return texto.replaceAll('.', ',');
  }

  /// `5,0` (uma casa), `—` para `null`: as células de nota da turma.
  static String notaUmaCasa(double? valor) =>
      valor == null ? '—' : valor.toStringAsFixed(1).replaceAll('.', ',');

  /// `7,25` (duas casas), usado no CR.
  static String duasCasas(double valor) =>
      valor.toStringAsFixed(2).replaceAll('.', ',');
}
