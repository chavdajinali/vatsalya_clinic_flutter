import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File?> compressImage(String path, String targetPath) async {
  return await FlutterImageCompress.compressAndGetFile(
    path, // Source file path
    targetPath, // Target file path
    quality: 30, // Compression quality (1-100)
  );

}
