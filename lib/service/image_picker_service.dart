import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  Future<XFile?> call(BuildContext context) async {
    return showModalActionSheet(
      context: context,
      actions: [
        const SheetAction(label: 'Gallery', key: 'gallery'),
        const SheetAction(label: 'Camera', key: 'camera'),
      ],
    ).then((selectedOption) {
      switch (selectedOption) {
        case 'gallery':
          return _pickImage(context, ImageSource.gallery);
        case 'camera':
          return _pickImage(context, ImageSource.camera);
        default:
          return null;
      }
    });
  }

  Future<XFile?> _pickImage(BuildContext context, ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) return _cropImage(context, pickedFile);
    return null;
  }

  Future<XFile?> _cropImage(BuildContext context, XFile file) async {
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) return file;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: CropAspectRatioPreset.values,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).appBarTheme.backgroundColor,
          toolbarWidgetColor:
              Theme.of(context).appBarTheme.titleTextStyle?.color,
          backgroundColor: Theme.of(context).colorScheme.background,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile == null) return null;
    return XFile.fromData(
      await croppedFile.readAsBytes(),
      path: file.path,
    );
  }
}
