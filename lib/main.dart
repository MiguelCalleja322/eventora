import 'package:flutter/material.dart';
import 'Auth/login.dart';
import 'Auth/signup.dart';
void main() => runApp(const MaterialApp(
  initialRoute: '/',
  onGenerateRoute: Routes.generateRoutes,
));


class Routes {
  static Route<dynamic>? generateRoutes(RouteSettings routeSettings){
    final args = routeSettings.arguments;

    switch (routeSettings.name){
      case '/':
        return MaterialPageRoute(
          builder: (_) => Login(), settings: routeSettings
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => Signup(), settings: routeSettings
        );
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