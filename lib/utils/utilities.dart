import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Image;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

  static String getInitials(fullName) {
    List<String> fullNameSplits = fullName.split(" ");
    String firstNameInitial = fullNameSplits[0][0];
    String lastNameInitial = fullNameSplits[1][0];

    print(fullName);

    return firstNameInitial + lastNameInitial;
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(1457);
    Image.Image image = Image.decodeImage(imageToCompress.readAsBytesSync());
    Image.copyResize(image, width: 500, height: 500);
    return new File("$path/image_$random.jpg")..writeAsBytesSync(Image.encodeJpg(image, quality: 85));


  }
  static Future<File> pickImage({@required ImageSource source}) async {
    File selectedImage = await ImagePicker.pickImage(source: source);
    return compressImage(selectedImage);
  }
}
