import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banka_flutter/presentation/screens/security/pin_screen.dart';

final appLockedProvider = StateProvider<bool>((ref) => true);

class AppLockGate extends ConsumerWidget {
  const AppLockGate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locked = ref.watch(appLockedProvider);
    if (locked) {
      return PinScreen(
        onUnlocked: () => ref.read(appLockedProvider.notifier).state = false,
      );
    }
    return child;
  }
}
