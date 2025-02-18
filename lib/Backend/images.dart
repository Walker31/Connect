import 'dart:io';
import 'package:connect/Backend/path.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class ImageUploadService {
  static Logger logger = Logger();

  static Future<bool> uploadImage(File image) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiPath.uploadImage()));

      request.files.add(await http.MultipartFile.fromPath(
        'images',
        image.path,
        filename: basename(image.path),
      ));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        logger.d('Upload Successful: $responseBody');
        return true;
      } else {
        logger.d('Upload Failed: $responseBody');
        return false;
      }
    } catch (e) {
      logger.e('Error uploading image: $e');
      return false;
    }
  }
}
