import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banka_flutter/app.dart';
import 'package:banka_flutter/core/bootstrap/backend_init.dart' deferred as backend;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BunqPWAApp()));
  // Defer heavy SDK init until after first frame (LCP / TBT).
  SchedulerBinding.instance.addPostFrameCallback((_) {
    _initBackend();
  });
}

Future<void> _initBackend() async {
  try {
    await backend.loadLibrary();
    await backend.initBackend();
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('Backend init failed: $e\n$st');
    }
  }
}
