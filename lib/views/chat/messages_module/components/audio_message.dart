import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/utils/functions.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/blocs/chat/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String audioURL = StorageKey.pCONVERSATION;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  Widget build(BuildContext context) {
    final ChatBloc chatBloc = context.read<ChatBloc>();
    return StreamBuilder<String?>(
        stream: chatBloc.getFile(fileName: widget.url),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            audioURL = snapshot.data!;
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
          }
          return GestureDetector(
            onTap: () async {
              if (snapshot.hasData) {
                if (isPlaying) {
                  await audioPlayer.pause();
                } else {
                  await audioPlayer.play(UrlSource(audioURL));
                }
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
        });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
