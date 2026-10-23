import 'package:flutter/material.dart';
import 'package:banka_flutter/core/theme/app_theme.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key, this.onUnlocked});
  final VoidCallback? onUnlocked;

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  int _attempts = 0;
  bool _locked = false;
  int _lockSeconds = 0;

  static const _demoPin = '1234';

  void _addDigit(String d) {
    if (_locked || _pin.length >= 4) return;
    setState(() => _pin += d);
    if (_pin.length == 4) _check();
  }

  void _backspace() {
    if (_locked || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _check() {
    if (_pin == _demoPin) {
      widget.onUnlocked?.call();
      setState(() => _pin = '');
    } else {
      setState(() {
        _attempts++;
        _pin = '';
      });
      if (_attempts >= 3) {
        setState(() {
          _locked = true;
          _lockSeconds = 30;
        });
        _startLockTimer();
      }
    }
  }

  void _startLockTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _lockSeconds--);
      if (_lockSeconds <= 0) {
        setState(() {
          _locked = false;
          _attempts = 0;
        });
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: AppColors.brand),
              const SizedBox(height: 16),
              const Text('Zadaj PIN', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                _locked ? 'Zablokované na $_lockSeconds s' : 'Demo PIN: 1234',
                style: TextStyle(color: _locked ? Colors.red : Colors.grey),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.brand : Colors.transparent,
                      border: Border.all(color: AppColors.brand, width: 2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              _PinPad(
                onDigit: _addDigit,
                onBackspace: _backspace,
                disabled: _locked,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinPad extends StatelessWidget {
  const _PinPad({required this.onDigit, required this.onBackspace, this.disabled = false});
  final void Function(String) onDigit;
  final VoidCallback onBackspace;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final digits = ['1','2','3','4','5','6','7','8','9','','0','⌫'];
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: digits.map((d) {
        if (d.isEmpty) return const SizedBox();
        final isBack = d == '⌫';
        return Material(
          color: AppColors.brand.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: disabled ? null : () => isBack ? onBackspace() : onDigit(d),
            child: Center(
              child: Text(
                d,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
