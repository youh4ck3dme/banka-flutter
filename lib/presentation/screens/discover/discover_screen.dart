import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {'icon': Icons.savings_outlined, 'title': 'Vklady', 'subtitle': 'Termínované a sporiace'},
      {'icon': Icons.credit_card_outlined, 'title': 'Karty', 'subtitle': 'Debetné a kreditné'},
      {'icon': Icons.calculate_outlined, 'title': 'Hypotéka', 'subtitle': 'Kalkulačka'},
      {'icon': Icons.trending_up_outlined, 'title': 'Investície', 'subtitle': 'Sprievodca'},
      {'icon': Icons.shield_outlined, 'title': 'Poistenie', 'subtitle': 'Ochrana'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objavujte'),
        actions: const [ThemeModeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Produkty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...products.map((p) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.brand.withOpacity(0.2),
                child: Icon(p['icon'] as IconData, color: AppColors.ink),
              ),
              title: Text(p['title'] as String),
              subtitle: Text(p['subtitle'] as String),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (p['title'] == 'Hypotéka') {
                  context.go('/mortgage');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${p['title']} – čoskoro')),
                  );
                }
              },
            ),
          )),
          const SizedBox(height: 24),
          const Text('Analytika', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Výdavky tento mesiac', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.brand.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('Donut / stĺpcový graf – čoskoro')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
