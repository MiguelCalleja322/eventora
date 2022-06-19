// ignore_for_file: library_private_types_in_public_api, unnecessary_const, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:mime_type/mime_type.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:path/path.dart' as p;

class S3 {
  static Future uploadFile(String path, File file) async {
    await dotenv.load(fileName: ".env");
    final String? s3Bucket = dotenv.env['AWS_BUCKET'];
    final String? poolID = dotenv.env['AWS_POOL_ID'];
    String nameOfFile = randomString();
    SimpleS3 _simpleS3 = SimpleS3();

    return await _simpleS3.uploadFile(
        file, s3Bucket, poolID, AWSRegions.usEast1,
        s3FolderPath: path, fileName: nameOfFile, debugLog: false);
  }

  static randomString() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        32, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}

class SimpleS3 {
  static const MethodChannel _methodChannel = const MethodChannel('simple_s3');

  static const EventChannel _eventChannel =
      const EventChannel("simple_s3_events");

  ///Provide stream of dynamic type. This stream contains upload percentage.
  Stream get getUploadPercentage => _eventChannel.receiveBroadcastStream();

  ///Upload function takes File, S3 bucket name, pool ID and region as required param
  ///Default access control is PUBLIC_READ
  ///Debugging is disable by default this will prevent any logs and messages
  ///To enable use debugLog:true
  Future<String> uploadFile(
    File file,
    String? bucketName,
    String? poolID,
    _AWSRegion region, {
    String s3FolderPath = "",
    String? fileName,
    _AWSRegion? subRegion,
    S3AccessControl accessControl = S3AccessControl.publicRead,
    bool useTimeStamp = false,
    TimestampLocation timeStampLocation = TimestampLocation.prefix,
    bool debugLog = false,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    String result = '';
    String contentType = '';
    String originalFileName = '';
    final fileExtension = p.extension(file.path);
    if (!await file.exists()) throw SimpleS3Errors.FileDoesNotExistsError;

    if (!(fileName != null && fileName.length > 0)) {
      originalFileName = file.path.split('/').last.replaceAll(" ", "");

      if (useTimeStamp) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;

        if (timeStampLocation == TimestampLocation.prefix) {
          fileName = '$timestamp' '\'_$originalFileName';
        } else {
          fileName =
              '${originalFileName.split(".").first}\_$timestamp\.${originalFileName.split(".").last}';
        }
      } else {
        fileName = originalFileName;
      }
    }

    String newFileName = '$fileName$fileExtension';

    print('filename:$newFileName');
    contentType = mime(newFileName)!;

    // if (debugLog) {
    //   debugPrint('S3 Upload Started <-----------------');
    //   debugPrint(" ");
    //   debugPrint("File Name: $fileName");
    //   debugPrint(" ");
    //   debugPrint("Content Type: $contentType");
    //   debugPrint(" ");
    // }

    args.putIfAbsent("filePath", () => file.path);
    args.putIfAbsent("poolID", () => poolID);
    args.putIfAbsent("region", () => region.region);
    args.putIfAbsent("bucketName", () => bucketName);
    args.putIfAbsent("fileName", () => newFileName);
    args.putIfAbsent("s3FolderPath", () => s3FolderPath);
    args.putIfAbsent("debugLog", () => debugLog);
    args.putIfAbsent("contentType", () => contentType);
    args.putIfAbsent(
        "subRegion", () => subRegion != null ? subRegion.region : "");
    args.putIfAbsent("accessControl", () => accessControl.index);

    print(args);

    bool methodResult = await _methodChannel.invokeMethod('upload', args);
    print(methodResult);
    // if (methodResult == true) {
    String? _region = subRegion != null ? subRegion.region : region.region;
    String? _path = s3FolderPath != ""
        ? "${bucketName!}/$s3FolderPath/$newFileName"
        : "${bucketName!}/$newFileName";

    result = "https://s3.$_region.amazonaws.com/$_path";

    // if (debugLog) {
    //   debugPrint("Status: Uploaded");
    //   debugPrint(" ");
    //   debugPrint("URL: $result");
    //   debugPrint(" ");
    //   debugPrint("Access Type: $accessControl");
    //   debugPrint(" ");
    //   debugPrint('S3 Upload Completed-------------->');
    //   debugPrint(" ");
    // } else {
    //   if (debugLog) {
    //     debugPrint("Status: Error");
    //     debugPrint(" ");
    //     debugPrint('S3 Upload Error------------------>');
    //   }
    //   throw SimpleS3Errors.UploadError;
    // }

    return result;
  }
}

class _AWSRegion {
  String region;

  _AWSRegion(this.region);
}

///AWS regions class created for consistency maintenance
///contains static getters which returns an private class internally.
class AWSRegions {
  static _AWSRegion get usEast1 => _AWSRegion("us-east-1");

  static _AWSRegion get usEast2 => _AWSRegion("us-east-2");

  static _AWSRegion get usWest1 => _AWSRegion("us-west-1");

  static _AWSRegion get usWest2 => _AWSRegion("us-west-2");

  static _AWSRegion get euWest1 => _AWSRegion("eu-west-1");

  static _AWSRegion get euWest2 => _AWSRegion("eu-west-2");

  static _AWSRegion get euWest3 => _AWSRegion("eu-west-3");

  static _AWSRegion get euNorth1 => _AWSRegion("eu-north-1");

  static _AWSRegion get euCentral1 => _AWSRegion("eu-central-1");

  static _AWSRegion get apSouthEast1 => _AWSRegion("ap-southeast-1");

  static _AWSRegion get apSouthEast2 => _AWSRegion("ap-southeast-2");

  static _AWSRegion get apNorthEast1 => _AWSRegion("ap-northeast-1");

  static _AWSRegion get apNorthEast2 => _AWSRegion("ap-northeast-2");

  static _AWSRegion get apSouth1 => _AWSRegion("ap-south-1");

  static _AWSRegion get apEast1 => _AWSRegion("ap-east-1");

  static _AWSRegion get saEast1 => _AWSRegion("sa-east-1");

  static _AWSRegion get cnNorth1 => _AWSRegion("cn-north-1");

  static _AWSRegion get caCentral1 => _AWSRegion("ca-central-1");

  static _AWSRegion get usGovWest1 => _AWSRegion("us-gov-west-1");

  static _AWSRegion get usGovEast1 => _AWSRegion("us-gov-east-1");

  static _AWSRegion get cnNorthWest1 => _AWSRegion("cn-northwest-1");

  static _AWSRegion get meSouth1 => _AWSRegion("me-south-1");
}

///TimeStamp enum
enum TimestampLocation { prefix, suffix }

///enum for Internal errors
// ignore: constant_identifier_names
enum SimpleS3Errors { FileDoesNotExistsError, UploadError, DeleteError }

enum S3AccessControl {
  unknown,
  private,
  publicRead,
  publicReadWrite,
  authenticatedRead,
  awsExecRead,
  bucketOwnerRead,
  bucketOwnerFullControl
}
