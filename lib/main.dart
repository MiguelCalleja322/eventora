import 'dart:io';
import 'package:eventora/Pages/Appointments/create_appointment.dart';
import 'package:eventora/Pages/Appointments/view_appointment.dart';
import 'package:eventora/Pages/Auth/auth_page.dart';
import 'package:eventora/Pages/Auth/otp.dart';
import 'package:eventora/Pages/Auth/user_preference.dart';
import 'package:eventora/Pages/Notes/create_notes.dart';
import 'package:eventora/Pages/Notes/list_notes.dart';
import 'package:eventora/Pages/Notes/view_note.dart';
import 'package:eventora/Pages/Auth/update_user_info.dart';
import 'package:eventora/Pages/Organizer/Events/create_events.dart';
import 'package:eventora/Pages/Organizer/Events/update_event.dart';
import 'package:eventora/Pages/Tasks/create_task.dart';
import 'package:eventora/Pages/Tasks/view_task.dart';
import 'package:eventora/Pages/User/create_user_events.dart';
import 'package:eventora/Pages/User/feed_page.dart';
import 'package:eventora/Pages/User/user_event_fullpage.dart';
import 'package:eventora/Pages/home.dart';
import 'package:eventora/Pages/messages_page.dart';
import 'package:eventora/Pages/notification.dart';
import 'package:eventora/Pages/other_profile.dart';
import 'package:eventora/Pages/payment.dart';
import 'package:eventora/Pages/saved_events_page.dart';
import 'package:eventora/Pages/search_results_page.dart';
import 'package:eventora/Pages/shared_events_page.dart';
import 'package:eventora/Pages/Organizer/wall.dart';
import 'package:eventora/Widgets/custom_calendar_update.dart';
import 'package:eventora/Widgets/custom_event_fullpage.dart';
import 'package:eventora/Widgets/custom_show_map.dart';
import 'package:eventora/controllers/auth_controller.dart';
import 'package:eventora/firebase_options.dart';
import 'package:eventora/services/api_services.dart';
import 'package:eventora/services/notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Pages/Auth/login.dart';
import 'Pages/Auth/signup.dart';
import 'Pages/User/feature_page.dart';
import 'utils/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  return Future<void>.value();
}

final fcmProvider =
    Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ProviderScope(
      child: MaterialApp(
          // initialRoute: '/home','
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.generateRoutes,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF7F8FB),
          ))));
}

class Routes {
  static Route<dynamic>? generateRoutes(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      // case '/':
      //   return MaterialPageRoute(
      //       builder: (_) => const Login(), settings: routeSettings);
      case '/':
        return MaterialPageRoute(
            builder: (_) => AuthPage(), settings: routeSettings);

      case '/home':
        return MaterialPageRoute(
            builder: (_) => const HomePage(), settings: routeSettings);
      //Auth
      case '/signup':
        return MaterialPageRoute(
            builder: (_) => Signup(), settings: routeSettings);

      case '/otp_page':
        return MaterialPageRoute(
            builder: (_) => const OTPPage(), settings: routeSettings);

      case '/user_preference':
        return MaterialPageRoute(
            builder: (_) => const UserPreferencePage(),
            settings: routeSettings);
      //notificatiosn
      case '/notifications':
        return MaterialPageRoute(
            builder: (_) => const NotificationsPage(), settings: routeSettings);
      //notes
      case '/create_notes':
        return MaterialPageRoute(
            builder: (_) => const CreateNotesPage(), settings: routeSettings);
      case '/list_notes':
        return MaterialPageRoute(
            builder: (_) => const CreateAndListNotes(),
            settings: routeSettings);
      case '/read_note':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => ShowNote(
                    title: args['title'],
                    description: args['description'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      //tasks
      case '/create_task':
        return MaterialPageRoute(
            builder: (_) => const CreateTask(), settings: routeSettings);
      case '/view_task':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => ViewTask(
                    title: args['title'],
                    description: args['description'],
                    dateTime: args['dateTime'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      //appointment
      case '/create_appointment':
        return MaterialPageRoute(
            builder: (_) => const CreateAppointment(), settings: routeSettings);
      case '/view_appointment':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => ViewAppointment(
                    title: args['title'],
                    description: args['description'],
                    dateTime: args['dateTime'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      //events

      case '/create_user_event':
        return MaterialPageRoute(
            builder: (_) => const CreateUserEvents(), settings: routeSettings);
      case '/feed_page':
        return MaterialPageRoute(
            builder: (_) => const FeedPage(), settings: routeSettings);
      case '/feature_page':
        return MaterialPageRoute(
            builder: (_) => const FeaturePage(), settings: routeSettings);
      case '/saved_events':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => SavedEvents(
                    savedEvents: args['savedEvents'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      case '/shared_events':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => SharedEventsPage(
                    sharedEvents: args['sharedEvents'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();
      case '/create_events':
        return MaterialPageRoute(
            builder: (_) => const CreateEvents(), settings: routeSettings);
      case '/update_event':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => UpdateEvent(
                    slug: args['slug'],
                    title: args['title'],
                    description: args['description'],
                    scheduleStart: args['scheduleStart'],
                    scheduleEnd: args['scheduleEnd'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      case '/custom_event_full':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => CustomEventFullPage(
                    slug: args['slug'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      case '/show_map':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => ShowMap(
                    latitude: args['latitude'],
                    longitude: args['longitude'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      //user
      case '/search':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => SearchResultPage(
                    title: args['title'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      case '/updateUserInfo':
        return MaterialPageRoute(
            builder: (_) => const UpdateUserInfo(), settings: routeSettings);

      case '/user_custom_event_full':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => UserEventFullPage(
                    slug: args['slug'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      case '/wall_page':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => WallPage(
                    type: args['type'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      case '/other_profile':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => OtherProfilePage(
                    username: args['username'],
                  ),
              settings: routeSettings);
        }
        return _errorRoute();

      //misc

      case '/update_calendar':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => CustomCalendarUpdatePage(
                  description: args['description'],
                  title: args['title'],
                  dateTime: args['schedule'],
                  id: args['id'],
                  model: args['model']),
              settings: routeSettings);
        }
        return _errorRoute();

      case '/payment':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
              builder: (_) => PaymentPage(
                    description: args['description'],
                    title: args['title'],
                    schedule: args['schedule'],
                    fees: args['fees'],
                    venue: args['venue'],
                    slug: args['slug'],
                    images: args['images'],
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
