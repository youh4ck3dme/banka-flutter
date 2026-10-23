import 'package:flutter/material.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = [
      {'name': 'Potraviny', 'value': 0.35, 'color': Colors.orange},
      {'name': 'Bývanie', 'value': 0.25, 'color': Colors.blue},
      {'name': 'Doprava', 'value': 0.15, 'color': Colors.green},
      {'name': 'Ostatné', 'value': 0.25, 'color': Colors.grey},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Analytika'), actions: const [ThemeModeToggleButton()]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Výdavky tento mesiac', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: cats.map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 140 * (c['value'] as double),
                        decoration: BoxDecoration(color: c['color'] as Color, borderRadius: BorderRadius.circular(6)),
                      ),
                      const SizedBox(height: 6),
                      Text(c['name'] as String, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Kategórie', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...cats.map((c) => ListTile(
            leading: CircleAvatar(backgroundColor: c['color'] as Color, radius: 8),
            title: Text(c['name'] as String),
            trailing: Text('${((c['value'] as double) * 100).toInt()} %'),
          )),
        ],
      ),
    );
  }
}
