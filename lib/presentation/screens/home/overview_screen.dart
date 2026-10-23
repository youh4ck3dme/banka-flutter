import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';
import 'package:banka_flutter/core/utils/csv_export.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool _balanceHidden = false;
  bool _loading = true;
  Timer? _idleTimer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _loading = false);
    });
    _resetIdle();
  }

  void _resetIdle() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 60), () {
      if (mounted && !_balanceHidden) {
        setState(() => _balanceHidden = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zostatok automaticky skrytý (nečinnosť)')),
        );
      }
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  void _showCallSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Zavolať na call centrum', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('0850 111 222'),
              subtitle: const Text('Nonstop'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Objednať stretnutie'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stretnutie – demo')));
              },
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
        title: const Text('Prehľad'),
        actions: [
          IconButton(
            icon: Icon(_balanceHidden ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _balanceHidden = !_balanceHidden),
            tooltip: 'Skryť/zobraziť zostatok',
          ),
          const ThemeModeToggleButton(),
        ],
      ),
      body: Listener(
        onPointerDown: (_) => _resetIdle(),
        child: RefreshIndicator(
          onRefresh: () async => Future.delayed(const Duration(milliseconds: 600)),
          child: _loading
              ? const _Skeleton()
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Balance card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.brand, AppColors.brandDeep],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: AppColors.brand.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Zostatok', style: TextStyle(color: AppColors.ink, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          _balanceHidden ? '••••••••' : '12 450,00 €',
                          style: const TextStyle(color: AppColors.ink, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text('Hlavný účet · SK00 0000 0000 0000', style: TextStyle(color: AppColors.ink)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Rýchle akcie', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _QuickAction(icon: Icons.send_rounded, label: 'Platba', onTap: () => context.go('/payment')),
                      _QuickAction(icon: Icons.qr_code_rounded, label: 'QR', onTap: () => context.go('/qr')),
                      _QuickAction(icon: Icons.credit_card_rounded, label: 'Karty', onTap: () => context.go('/cards')),
                      _QuickAction(icon: Icons.savings_rounded, label: 'Vklad', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vklad – čoskoro')))),
                      _QuickAction(icon: Icons.phone_outlined, label: 'Call', onTap: _showCallSheet),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Moje karty', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _CardPreview(last4: '4532', type: 'Debetná', onTap: () => context.go('/cards')),
                        const SizedBox(width: 12),
                        _CardPreview(last4: '8891', type: 'Kreditná', onTap: () => context.go('/cards')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Cieľ sporenia', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dovolenka 2027'),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: 0.65, backgroundColor: AppColors.brand.withOpacity(0.2), color: AppColors.brand),
                          const SizedBox(height: 4),
                          const Text('1 300 € / 2 000 €  (65 %)', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      final csv = demoCsv();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV pripravené (${csv.length} znakov)')));
                    },
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Export transakcií (CSV)'),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Posledné transakcie', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      TextButton(onPressed: () => context.go('/transactions'), child: const Text('Všetky')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(5, (i) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: AppColors.brand.withOpacity(0.2), child: Icon(Icons.shopping_bag_outlined, color: AppColors.ink)),
                      title: Text('Nákup ${i + 1}'),
                      subtitle: const Text('Dnes · 14:32'),
                      trailing: const Text('-24,90 €', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  )),
                ],
              ),
          ),
        ),
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  const _CardPreview({required this.last4, required this.type, this.onTap});
  final String last4;
  final String type;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(type, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const Spacer(),
            Text('•••• $last4', style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(6, (i) => Container(
        height: i == 0 ? 120 : 60,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
      )),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            CircleAvatar(radius: 28, backgroundColor: AppColors.brand.withOpacity(0.2), child: Icon(icon, color: AppColors.ink)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
