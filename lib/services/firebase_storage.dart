import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static Future<UploadTask?> uploadFile(
      String filePath, String fileName) async {
    File file = File(filePath);

    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref('files/$fileName').putFile(file);
      return uploadTask;
    } on FirebaseException catch (e) {
      print("EEEERRRRRROOOOOORRRRR $e");
      return null;
    }
  }
}
