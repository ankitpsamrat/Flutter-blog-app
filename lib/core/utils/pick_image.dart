import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      return File(image.path);
    }

    return null;
  } on Exception catch (e) {
    debugPrint('Error picking image: $e');
    return null;
  }
}
