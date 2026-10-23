import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';
import 'package:banka_flutter/core/utils/csv_export.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool _balanceHidden = false;
  Timer? _idleTimer;

  @override
  void initState() {
    super.initState();
    _resetIdle();
  }

  void _resetIdle() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 60), () {
      if (mounted && !_balanceHidden) {
        setState(() => _balanceHidden = true);
      }
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prehľad', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28)),
        actions: [
          IconButton(icon: const Icon(Icons.dark_mode_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.go('/settings')),
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
              const Positioned(right: 10, top: 10, child: CircleAvatar(radius: 4, backgroundColor: Colors.red)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(backgroundColor: AppColors.brand, child: Text('ZB', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: Listener(
        onPointerDown: (_) => _resetIdle(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _AccountCard(
              title: 'Bežný účet · EUR',
              balance: _balanceHidden ? '••••••' : '2 148,32 €',
              subtitle: 'Povolený debet 1 000 € · SK89 0200 0000 1234 5678 9101',
              eye: true,
              onEye: () => setState(() => _balanceHidden = !_balanceHidden),
              actions: [
                _YellowButton(icon: Icons.send_rounded, label: 'Platba', onTap: () => context.go('/payment')),
                _YellowButton(icon: Icons.qr_code_rounded, label: '', onTap: () => context.go('/qr'), small: true),
                _YellowButton(icon: Icons.receipt_long_outlined, label: 'Transakcie', onTap: () => context.go('/transactions')),
              ],
            ),
            const SizedBox(height: 12),
            _AccountCard(
              title: 'Sporiaci účet · EUR',
              balance: _balanceHidden ? '••••••' : '12 034,20 €',
              subtitle: 'Úrok 2,1 % p. a. · bez viazanosti',
              trailing: const CircleAvatar(backgroundColor: AppColors.brand, child: Text('%', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              actions: [
                _YellowButton(label: 'Sporiaci cieľ', onTap: () {}),
                _YellowButton(label: 'História', onTap: () => context.go('/transactions')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Quick(icon: Icons.send_rounded, label: 'Platba', onTap: () => context.go('/payment')),
                _Quick(icon: Icons.account_balance_wallet_outlined, label: 'Vklad', onTap: () {}),
                _Quick(icon: Icons.credit_card_rounded, label: 'Karty', onTap: () => context.go('/cards')),
                _Quick(icon: Icons.qr_code_rounded, label: 'QR kód', onTap: () => context.go('/qr')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Moje karty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _BankCard(type: 'DEBIT · Visa Classic', last4: '4839', name: 'ZDENKO BIRINGER', exp: '08/29', isCredit: false, onTap: () => context.go('/cards')),
                  const SizedBox(width: 12),
                  _BankCard(type: 'KREDIT', last4: '8891', name: 'ZDENKO BIRINGER', exp: '12/28', isCredit: true, onTap: () => context.go('/cards')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const _Donut(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _Legend(color: Color(0xFFFFD500), label: 'Bývanie', pct: '40%'),
                          _Legend(color: Color(0xFF4A90E2), label: 'Potraviny', pct: '25%'),
                          _Legend(color: Color(0xFFFF6B4A), label: 'Voľný čas', pct: '16%'),
                          _Legend(color: Color(0xFF7EC8E3), label: 'Doprava', pct: '11%'),
                          _Legend(color: Color(0xFFD0D0D0), label: 'Ostatné', pct: '8%'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Príjmy a výdavky', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        Text('posledných 6 mesiacov', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _BarChart(),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        _Dot(color: Color(0xFF4A90E2)),
                        SizedBox(width: 6),
                        Text('Príjmy', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 16),
                        _Dot(color: Color(0xFFFF6B4A)),
                        SizedBox(width: 6),
                        Text('Výdavky', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Posledné transakcie', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: Colors.black),
                  onPressed: () {
                    final csv = demoCsv();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV (${csv.length} zn)')));
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('CSV'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _Tx(icon: Icons.shopping_bag_outlined, title: 'Kaufland', sub: 'Dnes, 08:12', amount: '-24,87 €', neg: true),
            _Tx(icon: Icons.arrow_upward, title: 'Príplatok práca', sub: 'Včera, 18:30', amount: '+1 250,00 €', neg: false),
            _Tx(icon: Icons.home_outlined, title: 'Nájom – Byt', sub: '15. 10. 2026', amount: '-520,00 €', neg: true),
          ],
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.title, required this.balance, required this.subtitle, this.eye = false, this.onEye, this.trailing, required this.actions});
  final String title, balance, subtitle;
  final bool eye;
  final VoidCallback? onEye;
  final Widget? trailing;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(color: Colors.grey))),
                if (eye) IconButton(icon: const Icon(Icons.visibility_outlined), onPressed: onEye),
                if (trailing != null) trailing!,
              ],
            ),
            Text(balance, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(children: actions.map((a) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: a))).toList()),
          ],
        ),
      ),
    );
  }
}

class _YellowButton extends StatelessWidget {
  const _YellowButton({this.icon, required this.label, this.onTap, this.small = false});
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool small;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: AppColors.brand, foregroundColor: Colors.black, padding: EdgeInsets.symmetric(vertical: small ? 10 : 12, horizontal: small ? 8 : 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      onPressed: onTap,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [if (icon != null) Icon(icon, size: 18), if (icon != null && label.isNotEmpty) const SizedBox(width: 6), if (label.isNotEmpty) Text(label, style: const TextStyle(fontWeight: FontWeight.w600))]),
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(children: [InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]), child: Icon(icon, color: AppColors.brand))), const SizedBox(height: 6), Text(label, style: const TextStyle(fontSize: 12))]);
  }
}

class _BankCard extends StatelessWidget {
  const _BankCard({required this.type, required this.last4, required this.name, required this.exp, required this.isCredit, this.onTap});
  final String type, last4, name, exp;
  final bool isCredit;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(colors: isCredit ? [const Color(0xFFC8A16E), const Color(0xFF8B6914)] : [AppColors.brand, AppColors.brandDeep], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(type, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 13)), if (!isCredit) const Icon(Icons.contactless_outlined, color: Colors.black54)]),
            const Spacer(),
            const Icon(Icons.sim_card, color: Colors.black54, size: 28),
            const Spacer(),
            Text('•••• •••• •••• $last4', style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('DRŽITEĽ', style: TextStyle(fontSize: 9, color: Colors.black54)), Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))]), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('PLATNOSŤ', style: TextStyle(fontSize: 9, color: Colors.black54)), Text(exp, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))]), const Text('VISA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
          ],
        ),
      ),
    );
  }
}

class _Donut extends StatelessWidget {
  const _Donut();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(value: 1, strokeWidth: 14, backgroundColor: const Color(0xFFD0D0D0), color: const Color(0xFF7EC8E3)),
          CircularProgressIndicator(value: 0.92, strokeWidth: 14, color: const Color(0xFFFF6B4A), backgroundColor: Colors.transparent),
          CircularProgressIndicator(value: 0.76, strokeWidth: 14, color: const Color(0xFF4A90E2), backgroundColor: Colors.transparent),
          CircularProgressIndicator(value: 0.40, strokeWidth: 14, color: AppColors.brand, backgroundColor: Colors.transparent),
          const Column(mainAxisSize: MainAxisSize.min, children: [Text('1293 €', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('spolu', style: TextStyle(fontSize: 11, color: Colors.grey))]),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, required this.pct});
  final Color color;
  final String label, pct;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [CircleAvatar(radius: 5, backgroundColor: color), const SizedBox(width: 8), Expanded(child: Text(label, style: const TextStyle(fontSize: 13))), Text(pct, style: const TextStyle(fontWeight: FontWeight.w600))]));
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart();
  @override
  Widget build(BuildContext context) {
    final months = ['Máj', 'Jún', 'Júl', 'Aug', 'Sep', 'Okt'];
    final income = [0.7, 0.85, 0.75, 0.9, 0.8, 0.82];
    final expense = [0.55, 0.6, 0.5, 0.58, 0.52, 0.5];
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(6, (i) => Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Container(width: 10, height: 90 * income[i], color: const Color(0xFF4A90E2), margin: const EdgeInsets.only(right: 2)), Container(width: 10, height: 90 * expense[i], color: const Color(0xFFFF6B4A))]),
              const SizedBox(height: 4),
              Text(months[i], style: const TextStyle(fontSize: 10)),
            ],
          ),
        )),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

class _Tx extends StatelessWidget {
  const _Tx({required this.icon, required this.title, required this.sub, required this.amount, required this.neg});
  final IconData icon;
  final String title, sub, amount;
  final bool neg;
  @override
  Widget build(BuildContext context) {
    return Card(margin: const EdgeInsets.only(bottom: 8), child: ListTile(leading: CircleAvatar(backgroundColor: Colors.grey.shade100, child: Icon(icon, size: 20, color: Colors.black54)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(sub, style: const TextStyle(fontSize: 12)), trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.w600, color: neg ? Colors.black : Colors.green))));
  }
}
