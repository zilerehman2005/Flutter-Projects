import 'package:flutter/material.dart';

import '../screens/screens.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.chat:
        return MaterialPageRoute<void>(
          builder: (_) => const ChatScreen(),
          settings: settings,
        );
      case AppRoutes.history:
        return MaterialPageRoute<void>(
          builder: (_) => const HistoryScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: AppRoutes.splash),
        );
    }
  }
}
