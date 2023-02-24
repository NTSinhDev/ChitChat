import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/presentation/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioMessage extends StatefulWidget {
  final String url;
  final Color colorMsg;
  final Color colorShadow;
  final BorderRadiusGeometry borderMsg;
  final MainAxisAlignment mainAlign;
  const AudioMessage({
    super.key,
    required this.url,
    required this.colorMsg,
    required this.borderMsg,
    required this.colorShadow,
    required this.mainAlign,
  });

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  final audioPlayer = AudioPlayer();
  String audioURL = 'https://appsocketonline2.herokuapp.com';
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    audioURL = audioURL + widget.url;
    audioPlayer.setSourceUrl(audioURL);

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isPlaying) {
          await audioPlayer.pause();
        } else {
          await audioPlayer.play(UrlSource(audioURL));
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.h),
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: widget.colorMsg,
          borderRadius: widget.borderMsg,
          boxShadow: [
            BoxShadow(
              color: widget.colorShadow,
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                } else {
                  await audioPlayer.play(UrlSource(audioURL));
                }
              },
              child: Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 160.w,
              height: 2,
              child: Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.white54,
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {},
              ),
            ),
            Text(
              formatDuration(duration - position),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.white, fontSize: 12.h),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
