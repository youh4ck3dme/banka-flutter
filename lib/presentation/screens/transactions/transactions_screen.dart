import 'package:flutter/material.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';
import 'package:banka_flutter/core/utils/csv_export.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transakcie'),
        actions: [
          const ThemeModeToggleButton(),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              final csv = demoCsv();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exportované (${csv.split('\n').length - 1} riadkov)')),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demoTransactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final t = demoTransactions[i];
          final isNegative = (t['amount'] as String).startsWith('-');
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.brand.withOpacity(0.2),
                child: Icon(
                  isNegative ? Icons.arrow_upward : Icons.arrow_downward,
                  color: AppColors.ink,
                  size: 20,
                ),
              ),
              title: Text(t['desc'] as String),
              subtitle: Text(t['date'] as String),
              trailing: Text(
                '${t['amount']} €',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isNegative ? Colors.red.shade700 : Colors.green.shade700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
