import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayStopButton extends StatefulWidget {
  final String link;
  final bool isProtrait;
  const PlayStopButton({Key? key, required this.link, required this.isProtrait})
      : super(key: key);

  @override
  State<PlayStopButton> createState() => _PlayStopButtonState();
}

class _PlayStopButtonState extends State<PlayStopButton> {
  AudioPlayer player = AudioPlayer();

  late StreamSubscription<bool> playingListener;

  late StreamSubscription<ProcessingState> processingStateListener;

  bool _isPlaying = false;

  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    playingListener = player.playingStream.listen(
      (event) {
        setState(() {
          _isPlaying = event;
        });
      },
    );
    processingStateListener = player.processingStateStream.listen(
      (event) {
        if (event == ProcessingState.completed) {
          setState(() {
            _isLoading = false;
            _isPlaying = false;
          });
        } else {
          setState(() {
            _isLoading = event == ProcessingState.loading;
          });
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    playingListener.cancel();
    processingStateListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          _isPlaying ? stop() : play();
        },
        child: Padding(
          padding:
              widget.isProtrait ? EdgeInsets.all(4.0) : EdgeInsets.all(8.0),
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )),
                )
              : Icon(_isPlaying ? Icons.stop : Icons.play_arrow,
                  color: Colors.amber),
        ));
  }

  play() async {
    await player.setAudioSource(ProgressiveAudioSource(Uri.parse(widget.link)));
    await player.play();
    setState(() {
      _isPlaying = true;
    });
  }

  stop() async {
    await player.stop();
  }
}
