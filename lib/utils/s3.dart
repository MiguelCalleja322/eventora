import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class S3 {
  static Future uploadFile(String newFileName, File file) async {
    await dotenv.load(fileName: ".env");
    final String? s3Bucket = dotenv.env['AWS_BUCKET'];
    final String? s3AccessId = dotenv.env['AWS_ACCESS_KEY_ID'];
    final String? s3SecretKey = dotenv.env['AWS_SECRET_ACCESS_KEY'];
    final String? s3Endpoint = dotenv.env['AWS_ENDPOINT'];
    final String? s3Region = dotenv.env['AWS_DEFAULT_REGION'];

    final minio = Minio(
      region: s3Region!,
      endPoint: s3Endpoint!,
      accessKey: s3AccessId!,
      secretKey: s3SecretKey!,
    );

    File compressedFile =
        await S3().testCompressAndGetFile(file.absolute.path, newFileName);

    print(compressedFile.path);

    // await minio.fPutObject(
    //     s3Bucket!, 'events/$newFileName', compressedFile.path);

    // final url =
    //     await minio.presignedGetObject(s3Bucket, newFileName, expires: 1000);
    // print(url);
  }

  Future<File> testCompressAndGetFile(String path, String newFileName) async {
    Directory tempDir = await getTemporaryDirectory();

    String sourceTmpPath = '${tempDir.path}/$newFileName';
    var result = await FlutterImageCompress.compressAndGetFile(
        path, sourceTmpPath,
        quality: 50, format: CompressFormat.jpeg);

    return result!;
  }
}
