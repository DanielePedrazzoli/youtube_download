import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:youtube_download/Pages/HomePage.dart';
import 'package:youtube_download/Widgets/downloadOption.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class UserComunication {
  bool _modalWindowOpen = false;
  UserComunication();

  bool get isModalWidnowOpen => _modalWindowOpen;

  showLoader({required BuildContext context, required String text, bool overWriteWidow = false}) {
    if (_modalWindowOpen) {
      if (!overWriteWidow) log("Finestra già aperta, overWrite disabilitato");
      closeModal(context);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(text),
            ],
          ),
        );
      },
    );
    _modalWindowOpen = true;
  }

  Future<DownLoadOption?> showDownloadOption(BuildContext context, Video video) async {
    return await showDialog<DownLoadOption?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DownloadOptionWidget(video: video);
      },
    );
  }

  Future<void> showDownloadResult(BuildContext context, DonwloadResult result) async {
    String body = "Download del video effettuato";
    if (result.success == false) {
      body = "Download fallito";
    }

    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Donwload video'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(body),
                if (result.success) Text(result.nomeFile),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  closeModal(BuildContext context) {
    Navigator.pop(context);
    _modalWindowOpen = false;
  }
}
