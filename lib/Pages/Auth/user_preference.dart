// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/controllers/event_categories_controller.dart';
import 'package:eventora/controllers/user_preference_controller.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UserPreferencePage extends StatefulWidget {
  const UserPreferencePage({Key? key}) : super(key: key);

  @override
  State<UserPreferencePage> createState() => _UserPreferencePageState();
}

class _UserPreferencePageState extends State<UserPreferencePage> {
  late List<String>? userPreferredCategory = [];
  late Map<String, dynamic>? fetchedCategories = {};
  late List<dynamic>? eventCategories = [];
  late List options = [];

  void getEventCategories() async {
    fetchedCategories = await EventCategoriesController.index();
    if (fetchedCategories!.isNotEmpty) {
      setState(() {
        eventCategories = fetchedCategories!['event_categories'] ?? [];
      });
    }

    eventCategories!.forEach((category) {
      options.add({'title': category['type'], 'isActive': false});
    });
  }

  customBoxDecoration(isActive) {
    return BoxDecoration(
      color: isActive ? Colors.grey[800] : Colors.white,
      border: const Border(
          left: BorderSide(color: Colors.black12, width: 1.0),
          bottom: BorderSide(color: Colors.black12, width: 1.0),
          top: BorderSide(color: Colors.black12, width: 1.0),
          right: BorderSide(color: Colors.black12, width: 1.0)),
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }

  changeState(item) {
    if (userPreferredCategory!.contains(item['title'])) {
      userPreferredCategory!.remove(item['title']);
    } else {
      userPreferredCategory!.add(item['title']);
    }

    setState(() {
      item['isActive'] = !item['isActive'];
    });
  }

  void updateUserPreference() async {
    userPreferredCategory!.forEach((category) async {
      await UserPreferenceController.store(category);
    });

    Navigator.pushNamed(context, '/home');
  }

  @override
  void initState() {
    getEventCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateUserPreference();
        },
        backgroundColor: Colors.grey[850],
        child: const Icon(
          Ionicons.chevron_forward_circle_outline,
          color: Colors.white,
        ),
      ),
      appBar: const CustomAppBar(
        title: 'User Preference',
        hideBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Wrap(
                    spacing: 10.0,
                    runSpacing: 20.0,
                    children: options
                        .map((option) => Container(
                            decoration: customBoxDecoration(option['isActive']),
                            child: InkWell(
                                onTap: () {
                                  changeState(option);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text('${option['title']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: option['isActive']
                                                ? Colors.white
                                                : Colors.black87))))))
                        .toList()),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
