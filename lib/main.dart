import 'dart:io';
import 'package:eventora/Pages/Auth/otp.dart';
import 'package:eventora/Pages/Organizer/create_events.dart';
import 'package:eventora/Pages/Organizer/statistics.dart';
import 'package:eventora/Pages/User/update_user_info.dart';
import 'package:eventora/Pages/calendar.dart';
import 'package:eventora/Pages/home.dart';
import 'package:eventora/Pages/other_profile.dart';
import 'package:eventora/Pages/profile.dart';
import 'package:flutter/material.dart';
import 'Pages/Auth/login.dart';
import 'Pages/Auth/signup.dart';
import 'Pages/User/feature_page.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // ByteData data =
  //     await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  // SecurityContext.defaultContext
  //     .setTrustedCertificatesBytes(data.buffer.asUint8List());

  HttpOverrides.global = MyHttpOverrides();

  runApp(MaterialApp(
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
      case '/home':
        return MaterialPageRoute(
            builder: (_) => const HomePage(), settings: routeSettings);
      case '/signup':
        return MaterialPageRoute(
            builder: (_) => Signup(), settings: routeSettings);
      case '/feature_page':
        return MaterialPageRoute(
            builder: (_) => const FeaturePage(), settings: routeSettings);
      case '/otp_page':
        return MaterialPageRoute(
            builder: (_) => const OTPPage(), settings: routeSettings);
      case '/create_events':
        return MaterialPageRoute(
            builder: (_) => const CreateEvents(), settings: routeSettings);
      case '/statistics':
        return MaterialPageRoute(
            builder: (_) => const StatisticsPage(), settings: routeSettings);
      case '/calendar':
        return MaterialPageRoute(
            builder: (_) => const CalendarPage(), settings: routeSettings);
      case '/profile':
        return MaterialPageRoute(
            builder: (_) => const ProfilePage(), settings: routeSettings);
      case '/updateUserInfo':
        return MaterialPageRoute(
            builder: (_) => const UpdateUserInfo(), settings: routeSettings);

      case '/otherProfile':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => OtherProfilePage(
                    username: args['username'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

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
