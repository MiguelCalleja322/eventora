// ignore_for_file: unnecessary_const

import 'dart:io';
import 'dart:math';

import 'package:eventora/Widgets/custom_loading.dart';
import 'package:eventora/utils/s3.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/auth_controller.dart';
import 'package:path/path.dart' as path;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic>? profile = {};
  final ImagePicker imagePicker = ImagePicker();
  late int timestamp = DateTime.now().millisecondsSinceEpoch;
  late bool loading = false;
  late String? cloudFrontURI = '';
  void fetchProfile() async {
    // await dotenv.load(fileName: ".env");
    // cloudFrontURI = dotenv.env['CLOUDFRONT_URI'];

    setState(() {
      loading = true;
    });
    profile = await AuthController().getProfile();
    print(profile!['user']['avatar']);
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
                  padding: const EdgeInsets.all(15.0),
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
                                    Align(
                                      alignment: Alignment.center,
                                      child: Stack(children: [
                                        CircleAvatar(
                                          backgroundImage: profile!['user']
                                                      ['avatar'] ==
                                                  null
                                              ? const NetworkImage(
                                                  'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?t=st=1655378183~exp=1655378783~hmac=16554c48c3b8164f45fa8b0b0fc0f1af8059cb57600e773e4f66c6c9492c6a00&w=826')
                                              : NetworkImage(
                                                  'https://d2aobpa1aevk77.cloudfront.net/${profile!['user']['avatar']}'),
                                          radius: 90.0,
                                        ),
                                        Positioned(
                                            right: -15,
                                            top: 145,
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.update_outlined,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  openImages();
                                                })),
                                      ]),
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

  openImages() async {
    setState(() {
      loading = true;
    });
    try {
      String fileExtension = '';
      final XFile? selectedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      fileExtension = path.extension(selectedImage!.path);
      String newFileName =
          randomString() + '-' + timestamp.toString() + fileExtension;
      File image = File(selectedImage.path);

      await S3.uploadFile(newFileName, image, 'avatars');

      Map<String, dynamic> avatar = {'avatar': 'avatars/$newFileName'};

      await AuthController().userUpdate(avatar);

      setState(() {
        profile!['user']['avatar'] = 'avatars/$newFileName';
      });

      print(newFileName);
    } catch (e) {
      print('No images were picked. ${e}');
    }

    setState(() {
      loading = false;
    });
  }

  static randomString() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
