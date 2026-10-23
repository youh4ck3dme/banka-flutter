import 'dart:convert';

/// Jednoduchý CSV export pre demo transakcie.
String exportTransactionsCsv(List<Map<String, dynamic>> txs) {
  final buf = StringBuffer('Dátum,Popis,Suma\n');
  for (final t in txs) {
    final date = t['date'] ?? '';
    final desc = (t['desc'] ?? '').toString().replaceAll(',', ' ');
    final amount = t['amount'] ?? '';
    buf.writeln('$date,$desc,$amount');
  }
  return buf.toString();
}

/// Demo data
final demoTransactions = [
  {'date': '2026-10-22', 'desc': 'Tesco', 'amount': '-24.90'},
  {'date': '2026-10-21', 'desc': 'Nájom', 'amount': '-450.00'},
  {'date': '2026-10-20', 'desc': 'Výplata', 'amount': '1200.00'},
];

String demoCsv() => exportTransactionsCsv(demoTransactions);
