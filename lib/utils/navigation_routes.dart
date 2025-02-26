import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../features/presentation/views/dashboard/dashboard.dart';
import '../features/presentation/views/splash/splash_view.dart';

class Routes {
  static const String kSplashView = "kSplashView";
  static const String kDashboardView = "kDashboardView";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.kSplashView:
        return PageTransition(
            child: SplashView(), type: PageTransitionType.fade);
      case Routes.kDashboardView:
        return PageTransition(
            child: DashboardView(
              tab: settings.arguments != null ? settings.arguments as int : 1,
            ),
            type: PageTransitionType.fade);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Invalid Route"),
            ),
          ),
        );
    }
  }
}
