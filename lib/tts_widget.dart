import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsWidget extends StatefulWidget {
  final bool extened;
  final String labelPlay;
  final String labelStop;
  final double iconSize;
  final String textToSpeech;

  const TtsWidget({@required this.extened, this.iconSize = 50.0, @required this.textToSpeech, this.labelPlay, this.labelStop});

  @override
  _TtsWidgetState createState() => _TtsWidgetState();
}

class _TtsWidgetState extends State<TtsWidget> {
  FlutterTts flutterTts;
  ValueNotifier<bool> isPlaying = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();
    flutterTts.setLanguage('de-DE');
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() async {
      await _stopSpeech();
    });
  }

  _startSpeech() async {
    isPlaying.value = true;
    await flutterTts.speak(widget.textToSpeech.toLowerCase());
  }

  _stopSpeech() async {
    isPlaying.value = false;
    await flutterTts.stop();
  }

  @override
  void dispose() {
    flutterTts?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isPlaying,
      builder: (context, playing, child) {
        if (widget.extened) {
          if (playing) {
            return RaisedButton.icon(
              onPressed: () async => await _stopSpeech(),
              icon: Icon(Icons.stop, size: widget.iconSize),
              label: Text(widget.labelStop),
            );
          } else {
            return RaisedButton.icon(
              onPressed: () async => await _startSpeech(),
              icon: Icon(Icons.play_arrow, size: widget.iconSize),
              label: Text(widget.labelPlay),
            );
          }
        }

        if (playing) {
          return IconButton(
            icon: Icon(
              Icons.stop,
              size: widget.iconSize,
            ),
            padding: const EdgeInsets.all(0),
            onPressed: () async => await _stopSpeech(),
          );
        } else {
          return IconButton(
            icon: Icon(
              Icons.play_arrow,
              size: widget.iconSize,
            ),
            padding: const EdgeInsets.all(0),
            onPressed: () async => await _startSpeech(),
          );
        }
      },
    );
  }
}
