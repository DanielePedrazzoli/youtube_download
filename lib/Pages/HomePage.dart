// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:youtube_download/Comunication/UserComunication.dart';
import 'package:youtube_download/Database/Preference.dart';
import 'package:youtube_download/DownLoadManager.dart';
import 'package:youtube_download/Pages/SearchPage.dart';
import 'package:youtube_download/Widgets/searchBar.dart';
import 'package:youtube_download/Widgets/serachByLink.dart';
import 'package:youtube_download/locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  YoutubeExplode youtubeExplode = locator<YoutubeExplode>();
  UserComunication userComunication = locator<UserComunication>();
  DownLoadManager donwloadManager = locator<DownLoadManager>();

  List<Video> searchResult = [];
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

  /// Ricerca i video utilizzano lo schema di riceca selezionato
  /// Nel caso di ricerca tramite `SearchType.link` l'array conterrà sempre un
  /// singolo elemento se la ricerca è andata a buon fine
  Future<List<Video>> searchVideo(SearchType searchType, String value) async {
    userComunication.showLoader(context: context, text: "Riceca in corso");

    List<Video> result = [];

    switch (searchType) {
      case SearchType.link:
        result = [await youtubeExplode.videos.get(value)];

      case SearchType.search:
        var search = youtubeExplode.search(value);
        result = (await search.asStream().toList())[0];
    }
    userComunication.closeModal(context);
    return result;
  }

  /// Mostra del optioni di donwload all'untente e successivamente chiama il
  /// donwload del video se l'utentda conferma le opzioni
  void showDownloadOption(Video video) async {
    var downloadOption = await userComunication.showDownloadOption(context, video);

    if (downloadOption != null) {
      DonwloadResult result = await donwloadManager.download(context, downloadOption, video);
      userComunication.showDownloadResult(context, result);
    }
  }

  /// Apre la finestra modale per permettere all'utente di cercare il video
  /// direttamente tramite il link di youtube
  void openSearchByLink() async {
    String? link = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SearchByLink();
      },
    );

    if (link != null && link.isNotEmpty) {
      var video = await searchVideo(SearchType.link, link);
      showDownloadOption(video.first);
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
            CustomSearchBar(onStartSearch: (SearchType type, String text) async {
              searchResult = await searchVideo(type, text);
              setState(() {});
            }),
            const SizedBox(height: 15),
            SearchResultPage(result: searchResult, onResultTap: showDownloadOption)
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

enum SearchType { search, link }
