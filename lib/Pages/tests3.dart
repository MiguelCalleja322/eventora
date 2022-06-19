import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:eventora/utils/s3.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:simple_s3/simple_s3.dart';

class SimpleS3Test extends StatefulWidget {
  const SimpleS3Test({Key? key}) : super(key: key);

  @override
  SimpleS3TestState createState() => SimpleS3TestState();
}

class SimpleS3TestState extends State<SimpleS3Test> {
  File? selectedFile;

  // final SimpleS3 _simpleS3 = SimpleS3()
  bool isLoading = false;
  bool uploaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: StreamBuilder<dynamic>(
        //     stream: _simpleS3.getUploadPercentage,
        //     builder: (context, snapshot) {
        //       return Text(
        //         snapshot.data == null
        //             ? "Simple S3 Test"
        //             : "Uploaded: ${snapshot.data}",
        //       );
        //     }),
      ),
      body: Center(
        child: selectedFile != null
            ? isLoading
                ? const CircularProgressIndicator()
                : Image.file(selectedFile!)
            : GestureDetector(
                onTap: () async {
                  XFile pickedFile = (await ImagePicker()
                      .pickImage(source: ImageSource.gallery))!;
                  setState(() {
                    selectedFile = File(pickedFile.path);
                  });
                },
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
      ),
      floatingActionButton: !isLoading
          ? FloatingActionButton(
              backgroundColor: uploaded ? Colors.green : Colors.blue,
              child: Icon(
                uploaded ? Icons.delete : Icons.arrow_upward,
                color: Colors.white,
              ),
              onPressed: () async {
                _upload();
              },
            )
          : null,
    );
  }

  Future<String?> _upload() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        String path = await randomString();
        result = await S3.uploadFile('', selectedFile!);
        print(result);

        // result = await _simpleS3.uploadFile(
        //   selectedFile!,
        //   'lcits-eventora',
        //   'EH2RX2DM1B5JK',
        //   AWSRegions.usEast1,
        //   debugLog: true,
        //   accessControl: S3AccessControl.publicRead,
        // );

        setState(() {
          uploaded = true;
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  static randomString() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        32, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
