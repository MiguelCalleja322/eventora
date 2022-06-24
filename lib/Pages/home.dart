import 'package:eventora/Pages/Organizer/dashboard.dart';
import 'package:eventora/Pages/Organizer/statistics.dart';
import 'package:eventora/Pages/User/feature_page.dart';
import 'package:eventora/Pages/profile.dart';
import 'package:eventora/Pages/settings.dart';
import 'package:eventora/Widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/secure_storage.dart';
import 'calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? LoadingPage()
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    // Index = 0
                    role == 'user' ? const FeaturePage() : Dashboard(),

                    // Index = 1
                    role == 'user' ? const FeaturePage() : StatisticsPage(),

                    ProfilePage(),

                    // CalendarPage(),

                    // Index = 2
                    SettingsPage(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              backgroundColor: const Color(0xFFF7F8FB),
              selectedItemColor: Colors.green[800],
              currentIndex: _selectedIndex,
              elevation: 8,
              unselectedIconTheme: IconThemeData(
                color: Colors.grey[800],
              ),
              unselectedItemColor: Colors.grey[800],
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                role == 'user'
                    ? const BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      )
                    : const BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard),
                        label: 'Dashboard',
                      ),
                role == 'user'
                    ? const BottomNavigationBarItem(
                        icon: Icon(Icons.trending_up),
                        label: 'Features',
                      )
                    : const BottomNavigationBarItem(
                        icon: Icon(Icons.trending_up),
                        label: 'Statistics',
                      ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.face),
                  label: 'Profile',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'Calendar',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              onTap: _onItemTapped,
            ),
          );
  }
}
