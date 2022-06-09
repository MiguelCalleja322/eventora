import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/Widgets/custom_dashboard_button.dart';
import 'package:eventora/Widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvents extends StatefulWidget {
  CreateEvents({Key? key}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  late bool loading = false;
  openImages() async {
    setState(() {
      loading = true;
    });
    try {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      setState(() {
        imageFileList!.addAll(selectedImages!);
      });
    } catch (e) {
      print('No images were picked. ${e}');
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    if (imageFileList!.isEmpty)
                      DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: const Color.fromARGB(255, 132, 132, 132),
                                width: 2.0,
                                style: BorderStyle.solid)),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Center(
                              child: loading == true
                                  ? SpinKitCircle(
                                      size: 50.0,
                                      color: Colors.grey[700],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.image,
                                          color: Colors.grey[500],
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          'Choose Image',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    )),
                        ),
                      )
                    else
                      Stack(children: [
                        SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: CarouselSlider.builder(
                              itemCount: imageFileList!.length,
                              itemBuilder: (context, index, realIndex) {
                                return BuildImage(imageFileList![index], index);
                              },
                              options: CarouselOptions(
                                height: 300,
                                autoPlay: true,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 2),
                              )),
                        ),
                        Positioned(
                            right: -5,
                            top: -15,
                            child: IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.black.withOpacity(0.5),
                                  size: 20,
                                ),
                                onPressed: () {})),
                      ]),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        CustomDashboardButton(
                            height: 50.0,
                            width: double.infinity,
                            backgroundColor: Colors.grey[800],
                            borderRadius: BorderRadius.circular(25.0),
                            onPressed: () {
                              openImages();
                            },
                            padding: const EdgeInsets.all(15.0),
                            alignment: Alignment.center,
                            text: 'Choose Images',
                            color: Colors.grey[100],
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fit: BoxFit.scaleDown,
                            elevation: 18.0,
                            clipBehavior: Clip.antiAlias),
                        const SizedBox(
                          width: 15.0,
                        ),
                        CustomDashboardButton(
                            height: 50.0,
                            width: double.infinity,
                            backgroundColor: Colors.grey[800],
                            borderRadius: BorderRadius.circular(25.0),
                            onPressed: () {
                              setState(() {
                                imageFileList!.clear();
                                loading = false;
                              });
                            },
                            padding: const EdgeInsets.all(15.0),
                            alignment: Alignment.center,
                            text: 'Clear Selections',
                            color: Colors.grey[100],
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fit: BoxFit.scaleDown,
                            elevation: 18.0,
                            clipBehavior: Clip.antiAlias),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BuildImage(XFile assetImage, int index) => Container(
        color: Colors.grey[500],
        child: Image.asset(
          assetImage.path,
          fit: BoxFit.cover,
        ),
      );
}
