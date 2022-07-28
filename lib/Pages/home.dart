import 'package:eventora/Pages/Organizer/statistics.dart';
import 'package:eventora/Pages/User/feature_page.dart';
import 'package:eventora/Pages/Organizer/event_category.dart';
import 'package:eventora/Pages/User/feed_page.dart';
import 'package:eventora/Pages/profile.dart';
import 'package:eventora/Pages/settings.dart';
import 'package:eventora/Widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/secure_storage.dart';
import 'calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool loading = false;
  String? role;

  void _getRole() async {
    setState(() {
      loading = true;
    });
    await dotenv.load(fileName: ".env");
    final String? roleKey = dotenv.env['ROLE_KEY'];
    role = await StorageSevice().read(roleKey!);

    setState(() {
      loading = false;
    });
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    if (mounted) {
      _getRole();
    }

    super.initState();
  }

  @override
  void dispose() {
    _selectedIndex = 0;
    loading = false;
    role = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? const LoadingPage()
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    role == 'user' ? const FeedPage() : const EventCategory(),

                    role == 'user'
                        ? const FeaturePage()
                        : const StatisticsPage(),

                    const ProfilePage(),

                    const CalendarPage(),

                    // Index = 2
                    const SettingsPage(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              backgroundColor: const Color(0xFFF7F8FB),
              selectedItemColor: Colors.blue[700],
              currentIndex: _selectedIndex,
              elevation: 8,
              unselectedIconTheme: IconThemeData(
                color: Colors.grey[800],
              ),
              unselectedItemColor: Colors.grey[800],
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Ionicons.home_outline),
                  label: 'Home',
                ),
                role == 'user'
                    ? const BottomNavigationBarItem(
                        icon: Icon(Ionicons.trending_up),
                        label: 'Features',
                      )
                    : const BottomNavigationBarItem(
                        icon: Icon(Ionicons.stats_chart_outline),
                        label: 'Statistics',
                      ),
                const BottomNavigationBarItem(
                  icon: Icon(Ionicons.person_outline),
                  label: 'Profile',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Ionicons.calendar_clear_outline),
                  label: 'Calendar',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Ionicons.settings_outline),
                  label: 'Settings',
                ),
              ],
              onTap: _onItemTapped,
            ),
          );
  }
}
