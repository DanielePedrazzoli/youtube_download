import 'package:flutter/material.dart';
import 'package:youtube_download/Widgets/VideoResult.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadOptionWidget extends StatefulWidget {
  final Video video;
  const DownloadOptionWidget({super.key, required this.video});

  @override
  State<DownloadOptionWidget> createState() => _DownloadOptionWidgetState();
}

class _DownloadOptionWidgetState extends State<DownloadOptionWidget> {
  DownLoadOption option = DownLoadOption();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Video download"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            VideoResult(video: widget.video),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: option.donwloadVideo,
              onChanged: (newValue) {
                setState(() {
                  option.donwloadVideo = newValue;
                });
              },
              title: const Text("Includi il video"),
            ),
            if (option.donwloadVideo == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Risoluzione video"),
                  DropdownButton<Resolution>(
                    value: option.risoluzioneVideo,
                    items: List.generate(
                      Resolution.values.length,
                      (index) => DropdownMenuItem(
                        value: Resolution.values[index],
                        child: Text(Resolution.values[index].name),
                        onTap: () {},
                      ),
                    ),
                    onChanged: (value) => setState(() {
                      option.risoluzioneVideo = value!;
                    }),
                  ),
                ],
              ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text("Risoluzione Audio"),
            //     DropdownButton<Resolution>(
            //       value: option.risoluzioneAudio,
            //       items: List.generate(
            //         Resolution.values.length,
            //         (index) => DropdownMenuItem(
            //           value: Resolution.values[index],
            //           child: Text(Resolution.values[index].name),
            //           onTap: () {},
            //         ),
            //       ),
            //       onChanged: (value) => setState(() {
            //         option.risoluzioneAudio = value!;
            //       }),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annulla'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: const Text('Download'),
          onPressed: () {
            Navigator.of(context).pop(option);
          },
        ),
      ],
    );
  }
}

class DownLoadOption {
  bool donwloadVideo = false;
  Resolution risoluzioneVideo = Resolution.alta;
  Resolution risoluzioneAudio = Resolution.alta;
  DownLoadOption();
}

enum Resolution { bassa, media, alta }
