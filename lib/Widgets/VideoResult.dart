import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoResult extends StatelessWidget {
  final Video video;
  final Function(Video)? onTap;
  const VideoResult({super.key, required this.video, this.onTap});

  String calculateUploadTime() {
    if (video.uploadDate == null) return "";
    DateTime now = DateTime.now();
    DateTime uploadDate = video.uploadDate!;

    Duration difference = now.difference(uploadDate);

    var year = difference.inDays ~/ 365;
    if (year != 0) {
      if (year == 1) {
        return "1 anno fa";
      }
      return "$year anni fa";
    }

    var week = difference.inDays ~/ 7;
    if (week != 0) {
      if (week == 1) {
        return "1 settimana fa";
      }
      return "$week settimane fa";
    }

    var day = difference.inDays;
    if (day != 0) {
      if (day == 1) {
        return "Ieri";
      }
      return "$day giorni fa";
    }

    var hour = difference.inHours;
    if (hour != 0) {
      if (hour == 1) {
        return "1 ora fa";
      }
      return "$hour ore fa";
    }

    return "meno di 1 ora fa";
  }

  String calculateDuration() {
    if (video.duration == null) return "";

    var sTot = video.duration!.inSeconds;
    var s = sTot % 60;
    var m = sTot ~/ 60;
    var h = m ~/ 60;

    if (h != 0) {
      return "$h:${(m - h * 60).toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    }

    if (m != 0) {
      return "$m:${s.toString().padLeft(2, '0')}";
    }

    return "0:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!(video) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    video.thumbnails.mediumResUrl,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: Color.fromARGB(181, 0, 0, 0)),
                    child: Text(
                      calculateDuration(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),

            // footer

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      video.author,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      calculateUploadTime(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
