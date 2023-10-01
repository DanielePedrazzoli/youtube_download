// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_download/Comunication/UserComunication.dart';
import 'package:youtube_download/Database/Preference.dart';
import 'package:youtube_download/Pages/HomePage.dart';
import 'package:youtube_download/Widgets/downloadOption.dart';
import 'package:youtube_download/locator.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownLoadManager {
  Future<String> _getDownloadPath() async {
    Directory dir = await getTemporaryDirectory();
    return dir.path;
  }

  MuxedStreamInfo _getRequestResolutionVideo(List<MuxedStreamInfo> streamInfo, DownLoadOption option) {
    switch (option.risoluzioneVideo) {
      case Resolution.bassa:
        return streamInfo.last;

      case Resolution.media:
      case Resolution.alta:
        return streamInfo.first;
    }
  }

  Future<DonwloadResult> download(BuildContext context, DownLoadOption option, Video video) async {
    UserComunication userComunication = locator<UserComunication>();
    YoutubeExplode youtubeExplode = locator<YoutubeExplode>();
    UserPreference userPreference = locator<UserPreference>();

    DonwloadResult donwloadResult = DonwloadResult();
    userComunication.showLoader(context: context, text: "Donwload in corso", overWriteWidow: true);

    String nomeVideo = video.title;
    String fileType = "";
    String tempFolderPath = await _getDownloadPath();

    donwloadResult.nomeVideo = video.title;
    donwloadResult.pathSaved = "$tempFolderPath/$nomeVideo";

    var streamManifest = await youtubeExplode.videos.streamsClient.getManifest(video.id);

    Stream<List<int>> stream;

    if (option.donwloadVideo) {
      List<MuxedStreamInfo> listOfStream = streamManifest.muxed.sortByVideoQuality();
      MuxedStreamInfo streamInfo = _getRequestResolutionVideo(listOfStream, option);
      stream = youtubeExplode.videos.streamsClient.get(streamInfo);
      donwloadResult.nomeVideo += ".mp4";
      fileType = "video/mp4";
    } else {
      var streamInfo = streamManifest.audioOnly.sortByBitrate().last;
      stream = youtubeExplode.videos.streamsClient.get(streamInfo);
      donwloadResult.nomeVideo += ".mp3";
      fileType = "audio/mpeg";
    }
    var file = File(donwloadResult.pathSaved);

    try {
      var fileStream = file.openWrite();

      await stream.pipe(fileStream);

      await fileStream.flush();
      await fileStream.close();

      var pathSaved = await userPreference.saveFileToDirectory(file, donwloadResult.nomeVideo, fileType);
      donwloadResult.pathSaved = pathSaved!;
      donwloadResult.success = true;
      await file.delete();
    } catch (e) {
      donwloadResult.success = false;
      donwloadResult.error = e;
    }

    userComunication.closeModal(context);
    return donwloadResult;
  }
}
