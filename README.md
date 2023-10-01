# youtube_download

Permette di effettuare un download da yotube di un video.
Permette di scegliere se effettuare il download in `audio-only` o se includere anche il video.
Il file scaricato verrà rinominato con il nome del video di riferimento. L'estensione verrà aggiunta in base alla tipologia di download:
- audio-only: `.mp3`
- audio & video: `.mp4`

## Librerie
Questa applicazione funziona come wrap della libreia [youtube_explode_dart](https://pub.dev/packages/youtube_explode_dart) aggiungendogli quindi semplicemnte una interfaccia grafica.
Per il salvataggio dei file viene usata la libreia [flutter_file_dialog](https://pub.dev/packages/flutter_file_dialog).


