import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Pages/Auth/login.dart';
import 'Pages/Auth/signup.dart';
import 'Pages/feature_page.dart';
import 'Pages/example.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // ByteData data =
  //     await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  // SecurityContext.defaultContext
  //     .setTrustedCertificatesBytes(data.buffer.asUint8List());

  HttpOverrides.global = MyHttpOverrides();

  runApp(MaterialApp(
      // initialRoute: '/example',
      onGenerateRoute: Routes.generateRoutes,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FB),
      )));
}

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
      case '/example':
        return MaterialPageRoute(
            builder: (_) => const ItemsWidget(), settings: routeSettings);
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
