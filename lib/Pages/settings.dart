import 'package:eventora/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import '../Widgets/custom_appbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        height: 70,
        hideBackButton: true,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SettingsList(
                    lightTheme: const SettingsThemeData(
                        settingsListBackground: Colors.transparent,
                        settingsSectionBackground: Colors.transparent),
                    shrinkWrap: true,
                    sections: [
                      SettingsSection(
                        margin: EdgeInsetsDirectional.zero,
                        title: const Text('User Settings'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            onPressed: (context) => Navigator.pushNamed(
                              context,
                              '/updateUserInfo',
                            ),
                            leading: const Icon(Icons.update),
                            title: const Text('Update User Information'),
                          ),
                        ],
                      ),
                      // SettingsSection(
                      //   title: const Text('Common'),
                      //   tiles: <SettingsTile>[
                      //     SettingsTile.navigation(
                      //       leading: const Icon(Icons.language),
                      //       title: const Text('Language'),
                      //       value: const Text('English'),
                      //     ),
                      //     SettingsTile.switchTile(
                      //       onToggle: (value) {},
                      //       initialValue: true,
                      //       leading: const Icon(Icons.format_paint),
                      //       title: const Text('Enable custom theme'),
                      //     ),
                      //   ],
                      // ),
                      SettingsSection(
                        margin: EdgeInsetsDirectional.zero,
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            onPressed: (context) {
                              logout(context);
                            },
                            leading: const Icon(Icons.logout_outlined),
                            title: const Text('Logout'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ))),
    );
  }

  void logout(context) async {
    await AuthController().logout();
    await Navigator.pushReplacementNamed(context, '/');
  }
}
