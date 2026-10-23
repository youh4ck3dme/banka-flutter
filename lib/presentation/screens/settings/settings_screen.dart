import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banka_flutter/core/theme/theme_mode_provider.dart';
import 'package:banka_flutter/core/widgets/theme_mode_toggle.dart';
import 'package:banka_flutter/presentation/shell/app_lock_gate.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nastavenia'),
        actions: const [ThemeModeToggleButton()],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Tmavý režim'),
            subtitle: Text(mode == ThemeMode.dark ? 'Zapnutý' : 'Vypnutý'),
            trailing: Switch(
              value: mode == ThemeMode.dark,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).state = v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('PIN pri spustení'),
            subtitle: const Text('Vyžadovať PIN pri otvorení appky'),
            trailing: Switch(
              value: true,
              onChanged: (_) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifikácie'),
            subtitle: const Text('Platby, bezpečnosť, ciele'),
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Zamknúť appku'),
            onTap: () {
              ref.read(appLockedProvider.notifier).state = true;
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('O aplikácii'),
            subtitle: const Text('Banka 1.0.0 · Demo'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Banka',
                applicationVersion: '1.0.0',
                applicationLegalese: 'Demo banková aplikácia',
              );
            },
          ),
        ],
      ),
    );
  }
}
