import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final _amountCtrl = TextEditingController(text: '50.00');
  final _ibanCtrl = TextEditingController(text: 'SK00 0000 0000 0000 0000');
  String _payload = '0001*SK000000000000000000*50.00*EUR*Platba';

  void _generate() {
    final iban = _ibanCtrl.text.replaceAll(' ', '');
    final amount = _amountCtrl.text;
    setState(() {
      _payload = '0001*$iban*$amount*EUR*Platba';
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _ibanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR'),
        actions: const [ThemeModeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Generátor QR (SQR)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          TextField(
            controller: _ibanCtrl,
            decoration: const InputDecoration(labelText: 'IBAN', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Suma (€)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: AppColors.ink),
            onPressed: _generate,
            child: const Text('Vygenerovať'),
          ),
          const SizedBox(height: 20),
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: QrImageView(
                  data: _payload,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(_payload, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          const Text('Dekódovanie SQR / SPayd', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Vlož payload alebo naskenuj (demo)', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Payload', border: OutlineInputBorder(), hintText: '0001*SK... alebo SPD*1.0*...'),
            onSubmitted: (v) {
              String std = 'Neznámy';
              if (v.startsWith('0001')) std = 'SQR';
              else if (v.startsWith('SPD*')) std = 'SPayd';
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Detekovaný: $std')));
            },
          ),
        ],
      ),
    );
  }
}
