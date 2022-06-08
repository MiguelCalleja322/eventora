import 'dart:io';

import 'package:eventora/Widgets/custom_dashboard_button.dart';
import 'package:eventora/Widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvents extends StatefulWidget {
  CreateEvents({Key? key}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  openImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                'Create Event',
                style: TextStyle(color: Colors.grey[800], fontSize: 40.0),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Column(
                children: [
                  CustomDashboardButton(
                    height: 50.0,
                    width: double.infinity,
                    backgroundColor: Colors.blue[600],
                    borderRadius: BorderRadius.circular(15.0),
                    onPressed: () => openImages(),
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.center,
                    text: 'Choose Images',
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 15.0,
                    fit: BoxFit.scaleDown,
                  ),
                  imageFileList != null
                      ? Wrap(
                          children: imageFileList!.map((imageone) {
                            print(imageone.path);
                            return Card(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.file(File(imageone.path)),
                              ),
                            );
                          }).toList(),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
