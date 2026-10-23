import 'package:flutter/material.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final List<Map<String, dynamic>> _cards = [
    {'id': '1', 'type': 'Debetná', 'last4': '4532', 'blocked': false, 'limit': 1000},
    {'id': '2', 'type': 'Kreditná', 'last4': '8891', 'blocked': false, 'limit': 2500},
  ];

  void _toggleBlock(int index) {
    setState(() => _cards[index]['blocked'] = !_cards[index]['blocked']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_cards[index]['blocked'] ? 'Karta zablokovaná' : 'Karta odblokovaná')),
    );
  }

  void _changeLimit(int index) {
    final ctrl = TextEditingController(text: _cards[index]['limit'].toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Zmeniť limit'),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Denný limit (€)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Zrušiť')),
          TextButton(
            onPressed: () {
              final v = int.tryParse(ctrl.text);
              if (v != null) setState(() => _cards[index]['limit'] = v);
              Navigator.pop(ctx);
            },
            child: const Text('Uložiť'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moje karty'), actions: const [ThemeModeToggleButton()]),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cards.length,
        itemBuilder: (context, i) {
          final c = _cards[i];
          final blocked = c['blocked'] as bool;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 32,
                        decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(6)),
                        child: Center(child: Text('•••• ${c['last4']}', style: const TextStyle(color: Colors.white, fontSize: 10))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text('${c['type']} · ${c['last4']}', style: const TextStyle(fontWeight: FontWeight.w600))),
                      if (blocked) const Chip(label: Text('Blokovaná', style: TextStyle(fontSize: 11)), backgroundColor: Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Denný limit: ${c['limit']} €'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _toggleBlock(i),
                          child: Text(blocked ? 'Odblokovať' : 'Blokovať'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: AppColors.ink),
                          onPressed: () => _changeLimit(i),
                          child: const Text('Limity'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
