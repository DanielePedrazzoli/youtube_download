import 'dart:developer';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class UserPreference {
  bool _ready = false;

  DirectoryLocation? _pickedDirectory;

  UserPreference();

  get ready => _ready;

  Future<void> init() async {
    _ready = true;
  }

  Future<String?> saveFileToDirectory(File file, String fileName, String fileType) async {
    if (_pickedDirectory == null) {
      await pickSaveDirecotry();
    }

    if (_pickedDirectory == null) return null;

    return await FlutterFileDialog.saveFileToDirectory(
      directory: _pickedDirectory!,
      data: file.readAsBytesSync(),
      mimeType: fileType,
      fileName: fileName,
      replace: true,
    );
  }

  Future<void> pickSaveDirecotry() async {
    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      log("Picking directory not supported");
      return;
    }

    _pickedDirectory = await FlutterFileDialog.pickDirectory();
  }
}
