import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioMessage extends StatefulWidget {
  final String url;
  final bool isMsgOfUser;
  const AudioMessage({
    super.key,
    required this.url,
    required this.isMsgOfUser,
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
    final friend = context.watch<ChatBloc>().friend;
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return StreamBuilder<String?>(
        stream: context.read<ChatBloc>().getFile(fileName: widget.url),
        builder: (context, snapshot) {
          if (snapshot.hasData) initData(data: snapshot.data!);
          return GestureDetector(
            onTap: () => onPlayPause(isActive: snapshot.hasData),
            child: MessageWidget(
              isSender: widget.isMsgOfUser,
              friend: friend,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => onPlayPause(isActive: snapshot.hasData),
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ResColors.purpleMessage(theme: !theme),
                      ),
                      child: Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow,
                        color: buildColor(theme),
                      ),
                    ),
                  ),
                  Text(
                    "${SplitUtilities.formatDuration(position)}\t-\t${SplitUtilities.formatDuration(duration)}",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.white, fontSize: 12.h),
                  ),
                  Spaces.w4,
                ],
              ),
            ).cloneForAudio(
              context: context,
              ratio: position.inSeconds.toDouble() /
                  (duration.inSeconds.toDouble() == 0.0
                      ? 1
                      : duration.inSeconds.toDouble()),
              padding: 8.h,
            ),
          );
        });
  }

  Color buildColor(bool theme) => widget.isMsgOfUser
      ? Colors.white
      : theme
          ? Colors.white
          : Colors.black;

  initData({required data}) {
    log('🚀log⚡ $data');
    audioURL = data;
    audioPlayer.setSourceUrl(audioURL);
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
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

  onPlayPause({required bool isActive}) async {
    if (isActive) {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play(UrlSource(audioURL));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}
