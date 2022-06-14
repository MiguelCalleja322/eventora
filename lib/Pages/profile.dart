// ignore_for_file: unnecessary_const

import 'package:eventora/Widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic>? profile = {};
  late bool loading = false;
  void fetchProfile() async {
    setState(() {
      loading = true;
    });
    profile = await AuthController().getProfile();
    print(profile);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? LoadingPage()
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 500.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'https://i.pinimg.com/280x280_RS/0c/59/d3/0c59d3e2b3a045c209c6517238df4e37.jpg'),
                                        radius: 90.0,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      profile!['user']['name'],
                                      style: const TextStyle(
                                          color: Color(0xFF114F5A),
                                          letterSpacing: 2.0,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          children: const [
                                            Text(
                                              'Followers',
                                              style: TextStyle(
                                                  color: Color(0xFF114F5A),
                                                  letterSpacing: 1.0,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color: Color(0xFF114F5A),
                                                  letterSpacing: 1.0,
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: const [
                                            Text(
                                              'Following',
                                              style: TextStyle(
                                                  color: Color(0xFF114F5A),
                                                  letterSpacing: 1.0,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color: Color(0xFF114F5A),
                                                  letterSpacing: 1.0,
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: const [
                                            Text(
                                              'No. Events',
                                              style: TextStyle(
                                                  color: Color(0xFF114F5A),
                                                  letterSpacing: 1.0,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color: Color(0xFF114F5A),
                                                  letterSpacing: 1.0,
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      // width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                            primary: const Color(0xFFF7F8FB),
                                            backgroundColor:
                                                const Color(0xFF114F5A),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)))),
                                        child: const Text(
                                          'Follow',
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      // width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                            primary: const Color(0xFFF7F8FB),
                                            backgroundColor:
                                                const Color(0xFF114F5A),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)))),
                                        child: const Text(
                                          'Message',
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
