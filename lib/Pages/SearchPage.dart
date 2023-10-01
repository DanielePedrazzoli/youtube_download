import 'package:flutter/material.dart';
import 'package:youtube_download/Widgets/VideoResult.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchResultPage extends StatelessWidget {
  final List<Video> result;
  final Function(Video) onResultTap;
  const SearchResultPage({super.key, required this.result, required this.onResultTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 15,
      child: ListView.builder(
        itemCount: result.length,
        itemBuilder: (BuildContext context, int index) {
          return VideoResult(
            video: result[index],
            onTap: onResultTap,
          );
        },
      ),
    );
  }
}
