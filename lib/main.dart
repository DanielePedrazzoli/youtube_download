// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_download/Database/Preference.dart';
import 'package:youtube_download/Widgets/VideoResult.dart';
import 'package:youtube_download/Widgets/downloadOption.dart';
import 'package:youtube_download/Widgets/serachByLink.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff222222),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  YoutubeExplode youtubeExplode = YoutubeExplode();

  List<Video> searchResult = [];
  bool downloading = false;
  UserPreference userPreference = UserPreference();

  @override
  void dispose() {
    super.dispose();
    youtubeExplode.close();
  }

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    await userPreference.init();
  }

  void searchVideo() async {
    showLoader("Riceca in corso");

    var textToSearch = controller.text;
    var search = youtubeExplode.search(textToSearch);
    var result = await search.asStream().toList();
    Navigator.pop(context);
    searchResult = result[0];
    setState(() {});
  }

  Future<Video> serchByLink(String link) async {
    showLoader("Riceca in corso");
    var res = await youtubeExplode.videos.get(link);
    Navigator.pop(context);
    return res;
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      log("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<DonwloadResult> downLoadVideo(Video video, DownLoadOption option) async {
    DonwloadResult donwloadResult = DonwloadResult();
    donwloadResult.nomeVideo = video.title;
    downloading = true;
    showLoader("Donwload in corso");
    setState(() {});
    var streamManifest = await youtubeExplode.videos.streamsClient.getManifest(video.id);

    // Get highest quality muxed stream
    // var streamInfo = streamManifest.muxed.withHigestVideoQuality();

    // ...or highest bitrate audio-only stream
    // var streamInfo = streamManifest.audioOnly.withHigestBitrate()

    // ...or highest quality MP4 video-only stream
    // var streamInfo.videoOnly.where((e) => e.container == Container)
    final directoryPath = await getDownloadPath();
    String filePath = "$directoryPath/${video.title}";
    String nomeFile = video.title;
    String fileType = "";

    Stream<List<int>> stream;

    if (option.donwloadVideo) {
      var streamInfo = streamManifest.muxed.sortByVideoQuality();
      stream = youtubeExplode.videos.streamsClient.get(streamInfo.first);
      filePath += ".mp4";
      fileType = "video/mp4";
    } else {
      var streamInfo = streamManifest.audioOnly.sortByBitrate().last;
      stream = youtubeExplode.videos.streamsClient.get(streamInfo);
      filePath += ".mp3";
      fileType = "audio/mpeg";
    }
    var file = File(filePath);

    try {
      donwloadResult.nomeFile = filePath;
      var fileStream = file.openWrite();

      await stream.pipe(fileStream);

      await fileStream.flush();
      await fileStream.close();

      var pathSaved = await userPreference.saveFileToDirectory(file, nomeFile, fileType);
      donwloadResult.pathSaved = pathSaved!;
      donwloadResult.success = true;
      await file.delete();
      Navigator.pop(context);
      return donwloadResult;
    } catch (e) {
      donwloadResult.success = false;
      donwloadResult.error = e;
      Navigator.pop(context);
      return donwloadResult;
    }
  }

  void showDownloadOption(Video video) async {
    var downloadOption = await showDialog<DownLoadOption?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DownloadOptionWidget(video: video);
      },
    );

    if (downloadOption != null) {
      DonwloadResult result = await downLoadVideo(video, downloadOption);
      String body = "";
      if (result.success == false) {
        body = "Download fallito, probabilmente youtube ha cambiato le impostazioni o il video è troppo grande";
      } else {
        body = "Download del video effettuato";
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
  }

  void showLoader(String text) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
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
  }

  void openSearchByLink() async {
    String? link = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchByLink();
      },
    );

    if (link != null) {
      showDownloadOption(await serchByLink(link));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yotube serch & donwload"),
        actions: [
          IconButton(
            onPressed: openSearchByLink,
            icon: const Icon(Icons.link),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: (value) => setState(() {}),
                    onSubmitted: (_) => searchVideo(),
                    decoration: InputDecoration(
                        suffixIcon: controller.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  controller.clear();
                                  setState(() {});
                                },
                              ),
                        hintText: "Cerca su youtube",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2)),
                    cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                if (controller.text.isNotEmpty)
                  IconButton(
                    onPressed: searchVideo,
                    icon: const Icon(Icons.search),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              flex: 15,
              child: ListView.builder(
                itemCount: searchResult.length,
                itemBuilder: (BuildContext context, int index) {
                  return VideoResult(
                    video: searchResult[index],
                    onTap: showDownloadOption,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonwloadResult {
  bool success = false;
  String nomeFile = "";
  String nomeVideo = "";
  String pathSaved = "";
  dynamic error;
  DonwloadResult();
}
