import 'dart:convert';

import 'package:eventora/Pages/Organizer/statistics.dart';
import 'package:eventora/Pages/User/feature_page.dart';
import 'package:eventora/Pages/Organizer/event_category.dart';
import 'package:eventora/Pages/User/feed_page.dart';
import 'package:eventora/Pages/profile.dart';
import 'package:eventora/Pages/settings.dart';
import 'package:eventora/globals/strings.dart';
import 'package:eventora/models/user.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ionicons/ionicons.dart';

import '../utils/secure_storage.dart';
import 'calendar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

final userDetailsProvider = FutureProvider<User>((ref) async {
  String? userDetailsMap = await StorageSevice().read(userInfoKey);
  final Map<String, dynamic> userDetails = jsonDecode(userDetailsMap!);
  print(userDetails);
  return User.fromJson(userDetails);
});

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  late String? bearerToken = '';

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<User> user = ref.read(userDetailsProvider);
    return Scaffold(
      body: SafeArea(
        child: user.when(
            data: (User user) => Center(
                    child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    user.role!.type == 'user'
                        ? const FeedPage()
                        : const EventCategory(),

                    user.role!.type == 'user'
                        ? const FeaturePage()
                        : const StatisticsPage(),

                    const ProfilePage(),

                    const CalendarPage(),

                    // Index = 2
                    const SettingsPage(),
                  ],
                )),
            error: (err, stack) => Text('hey'),
            loading: () => Text('loading...')),
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
          // user.value!.role!.type == 'user'
          //     ? const BottomNavigationBarItem(
          //         icon: Icon(Ionicons.trending_up),
          //         label: 'Features',
          //       )
          //     :
          const BottomNavigationBarItem(
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
