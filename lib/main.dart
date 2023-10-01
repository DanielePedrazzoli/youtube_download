// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:youtube_download/Pages/HomePage.dart';
import 'package:youtube_download/locator.dart';

void main() {
  setupLocator();
  runApp(const YotubeDownload());
}

class YotubeDownload extends StatelessWidget {
  const YotubeDownload({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff222222),
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
