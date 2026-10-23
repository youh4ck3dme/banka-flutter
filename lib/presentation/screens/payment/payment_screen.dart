import 'package:flutter/material.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final List<Map<String, String>> _templates = [
    {'name': 'Nájom', 'recipient': 'SK12 3456 7890 1234', 'amount': '450.00'},
    {'name': 'Potraviny', 'recipient': 'SK98 7654 3210 9876', 'amount': '80.00'},
  ];

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _useTemplate(Map<String, String> t) {
    setState(() {
      _recipientController.text = t['recipient'] ?? '';
      _amountController.text = t['amount'] ?? '';
    });
  }

  void _saveTemplate() {
    if (_recipientController.text.isEmpty) return;
    setState(() {
      _templates.add({
        'name': _noteController.text.isEmpty ? 'Nová šablóna' : _noteController.text,
        'recipient': _recipientController.text,
        'amount': _amountController.text,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Šablóna uložená')),
    );
  }

  void _deleteTemplate(int index) {
    setState(() => _templates.removeAt(index));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Potvrdenie platby', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Príjemca: ${_recipientController.text}'),
            Text('Suma: ${_amountController.text} €'),
            if (_noteController.text.isNotEmpty) Text('Poznámka: ${_noteController.text}'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Zrušiť'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: AppColors.ink),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Platba odoslaná (demo)')),
                      );
                      _recipientController.clear();
                      _amountController.clear();
                      _noteController.clear();
                    },
                    child: const Text('Potvrdiť'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nová platba'),
        actions: const [ThemeModeToggleButton()],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _recipientController,
              decoration: const InputDecoration(
                labelText: 'Príjemca (IBAN / meno)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Zadaj príjemcu' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Suma (€)',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Zadaj sumu';
                if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Neplatná suma';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Poznámka (voliteľné)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: AppColors.ink,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _submit,
              child: const Text('Pokračovať', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Šablóny platieb', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                TextButton.icon(
                  onPressed: _saveTemplate,
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: const Text('Uložiť aktuálnu'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_templates.isEmpty)
              const Text('Žiadne šablóny', style: TextStyle(color: Colors.grey))
            else
              ..._templates.asMap().entries.map((e) {
                final t = e.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(t['name'] ?? ''),
                    subtitle: Text('${t['recipient']} · ${t['amount']} €'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteTemplate(e.key),
                    ),
                    onTap: () => _useTemplate(t),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
