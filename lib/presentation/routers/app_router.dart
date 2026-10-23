import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banka_flutter/core/widgets/deferred_screen.dart';
import 'package:banka_flutter/presentation/shell/app_shell.dart';
import 'package:banka_flutter/presentation/screens/auth/login_screen.dart';
import 'package:banka_flutter/presentation/screens/auth/register_screen.dart'
    deferred as register;
import 'package:banka_flutter/presentation/screens/auth/forgot_password_screen.dart'
    deferred as forgot;
import 'package:banka_flutter/presentation/screens/auth/verify_otp_screen.dart'
    deferred as otp;
import 'package:banka_flutter/presentation/screens/home/overview_screen.dart';
import 'package:banka_flutter/presentation/screens/discover/discover_screen.dart';
import 'package:banka_flutter/presentation/screens/contacts/contacts_screen.dart';
import 'package:banka_flutter/presentation/screens/accounts/accounts_screen.dart'
    deferred as accounts;
import 'package:banka_flutter/presentation/screens/payment/payment_screen.dart';
import 'package:banka_flutter/presentation/screens/qr/qr_screen.dart';
import 'package:banka_flutter/presentation/screens/cards/cards_screen.dart';
import 'package:banka_flutter/presentation/screens/settings/settings_screen.dart';
import 'package:banka_flutter/presentation/screens/transactions/transactions_screen.dart';
import 'package:banka_flutter/presentation/screens/analytics/analytics_screen.dart';
import 'package:banka_flutter/presentation/screens/profile/profile_screen.dart';
import 'package:banka_flutter/presentation/screens/notifications/notifications_screen.dart';
import 'package:banka_flutter/presentation/screens/discover/mortgage_calculator_screen.dart';
import 'package:banka_flutter/presentation/screens/profile/profile_screen.dart';
import 'package:banka_flutter/presentation/screens/security/security_screen.dart'
    deferred as security;

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        redirect: (c, s) => '/home',
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (c, s) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (c, s) => DeferredScreen(
          loader: () async {
            await register.loadLibrary();
            return register.RegisterScreen();
          },
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (c, s) => DeferredScreen(
          loader: () async {
            await forgot.loadLibrary();
            return forgot.ForgotPasswordScreen();
          },
        ),
      ),
      GoRoute(
        path: '/verify-otp',
        name: 'verifyOtp',
        builder: (c, s) => DeferredScreen(
          loader: () async {
            await otp.loadLibrary();
            return otp.VerifyOtpScreen(email: s.extra as String?);
          },
        ),
      ),
      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (c, s) => const OverviewScreen(),
          ),
          GoRoute(
            path: '/discover',
            name: 'discover',
            builder: (c, s) => const DiscoverScreen(),
          ),
          GoRoute(
            path: '/contacts',
            name: 'contacts',
            builder: (c, s) => const ContactsScreen(),
          ),
        ],
      ),
      // Other routes (outside shell for now)
      GoRoute(
        path: '/accounts',
        name: 'accounts',
        builder: (c, s) => DeferredScreen(
          loader: () async {
            await accounts.loadLibrary();
            return accounts.AccountsScreen();
          },
        ),
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (c, s) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/qr',
        name: 'qr',
        builder: (c, s) => const QrScreen(),
      ),
      GoRoute(
        path: '/cards',
        name: 'cards',
        builder: (c, s) => const CardsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (c, s) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/transactions',
        name: 'transactions',
        builder: (c, s) => const TransactionsScreen(),
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (c, s) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (c, s) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/mortgage',
        name: 'mortgage',
        builder: (c, s) => const MortgageCalculatorScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (c, s) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/security',
        name: 'security',
        builder: (c, s) => DeferredScreen(
          loader: () async {
            await security.loadLibrary();
            return security.SecurityScreen();
          },
        ),
      ),
    ],
  );
});
