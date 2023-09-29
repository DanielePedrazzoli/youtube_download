import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class UserPreference {
  bool _ready = false;
  dynamic _json = {};
  Map<PreferenceKey, String> _mappaKey = {};
  DirectoryLocation? _pickedDirectory;

  UserPreference();

  get ready => _ready;

  Future<void> init() async {
    String fileContent = await rootBundle.loadString("assets/preference/userPreference.json");
    _json = jsonDecode(fileContent);

    _mappaKey = {
      PreferenceKey.path: "saveDirectory",
      PreferenceKey.theme: "tema",
    };

    _ready = true;
  }

  dynamic getPreferenceVoice(PreferenceKey key) {
    return _json[_mappaKey[key]];
  }

  bool get isPathSelected {
    if (!_ready) return false;
    return _json[_mappaKey[PreferenceKey.path]] != null;
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

enum PreferenceKey { theme, path }
