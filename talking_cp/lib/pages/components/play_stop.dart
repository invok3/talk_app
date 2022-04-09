import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

class PlayStopButton extends StatefulWidget {
  final String link;
  final bool isProtrait;
  const PlayStopButton({Key? key, required this.link, required this.isProtrait})
      : super(key: key);

  @override
  State<PlayStopButton> createState() => _PlayStopButtonState();
}

class _PlayStopButtonState extends State<PlayStopButton> {
  FlutterSoundPlayer? player;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          player == null ? play() : stop();
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
              : Icon(player == null ? Icons.play_arrow : Icons.stop,
                  color: Colors.amber),
        ));
  }

  play() async {
    setState(() {
      _isLoading = true;
    });
    player = await FlutterSoundPlayer().openPlayer();
    await player
        ?.startPlayer(fromURI: widget.link, whenFinished: stop)
        .whenComplete(
          () => setState(() {
            _isLoading = false;
          }),
        );
    setState(() {});
  }

  stop() async {
    await player?.stopPlayer();
    await player?.closePlayer();
    player = null;
    setState(() {});
  }
}
