import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
   static Future<File> pickImage({@required ImageSource source}) async {
    PickedFile file = await ImagePicker().getImage(
        source: source, maxWidth: 500, maxHeight: 500, imageQuality: 85);
    File selectedImage = File(file.path);
    return selectedImage;
  }
}
