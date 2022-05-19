import 'package:flutter/material.dart';
import 'Auth/login.dart';
import 'Auth/signup.dart';
import 'Pages/feature_page.dart';

void main() => runApp(MaterialApp(
    // initialRoute: '/feature_page',
    onGenerateRoute: Routes.generateRoutes,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F8FB),
    )));

class Routes {
  static Route<dynamic>? generateRoutes(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => Login(), settings: routeSettings);
      case '/signup':
        return MaterialPageRoute(
            builder: (_) => Signup(), settings: routeSettings);
      case '/feature_page':
        return MaterialPageRoute(
            builder: (_) => FeaturePage(), settings: routeSettings);
      default:
        _errorRoute();
    }
    return null;
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
