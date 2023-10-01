import 'package:get_it/get_it.dart';
import 'package:youtube_download/Comunication/UserComunication.dart';
import 'package:youtube_download/Database/Preference.dart';
import 'package:youtube_download/DownLoadManager.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final locator = GetIt.I;
void setupLocator() {
  locator.registerSingleton<UserPreference>(UserPreference());
  locator.registerSingleton<YoutubeExplode>(YoutubeExplode());
  locator.registerSingleton<UserComunication>(UserComunication());
  locator.registerSingleton<DownLoadManager>(DownLoadManager());
}
