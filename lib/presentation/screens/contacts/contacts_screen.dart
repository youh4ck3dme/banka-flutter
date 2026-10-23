import 'package:flutter/material.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _nameCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_nameCtrl.text.isEmpty || _msgCtrl.text.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Správa odoslaná (demo)')),
    );
    _nameCtrl.clear();
    _msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontakty'),
        actions: const [ThemeModeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('FAQ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const ExpansionTile(
            title: Text('Ako zmením PIN?'),
            children: [ListTile(title: Text('V Nastaveniach → Bezpečnosť → Zmeniť PIN.'))],
          ),
          const ExpansionTile(
            title: Text('Ako exportujem transakcie?'),
            children: [ListTile(title: Text('V Prehľade → Export CSV.'))],
          ),
          const SizedBox(height: 24),
          const Text('Napíšte nám', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Meno', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _msgCtrl,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Správa', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _send,
            child: const Text('Odoslať'),
          ),
        ],
      ),
    );
  }
}
