import 'package:chat_app/view_model/providers/theme_provider.dart';
import 'package:chat_app/views/chat/messages_module/components/cannot_load_img.dart';
import 'package:chat_app/views/chat/messages_module/components/loading_msg.dart';
import 'package:chat_app/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoMessage extends StatefulWidget {
  final List<String> urlList;
  final bool isMsgOfUser;

  const VideoMessage({
    super.key,
    required this.urlList,
    required this.isMsgOfUser,
  });

  @override
  State<VideoMessage> createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  late VideoPlayerController _playerController;
  late Future<void> _initializeVideoPlayerFuture;
  late bool theme;
  bool _isShowAction = false;

  @override
  void initState() {
    super.initState();
    _playerController = VideoPlayerController.network(
      '',
    );
    _initializeVideoPlayerFuture = _playerController.initialize();
    _playerController.setLooping(true);
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = context.watch<ThemeProvider>().isDarkMode;
    final maxWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: widget.isMsgOfUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: widget.urlList.map((url) {
        return FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: maxWidth * 7 / 10,
                  maxHeight: 440.h,
                ),
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color:
                          widget.isMsgOfUser ? Colors.black45 : Colors.black12,
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: CannotLoadMsg(
                  isSender: widget.isMsgOfUser,
                  theme: theme,
                  content: AppLocalizations.of(context)!.cannot_load_video,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                onTap: () async {
                  setState(() => _isShowAction = !_isShowAction);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    width: maxWidth * 7 / 10,
                    margin: EdgeInsets.only(top: 2.h),
                    child: AspectRatio(
                      aspectRatio: _playerController.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_playerController),
                          if (_isShowAction) ...[
                            Container(
                              color: Colors.black.withOpacity(0.6),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  _pauseAndPlayButton(),
                                  _videoProgressBar(),
                                ],
                              ),
                            )
                          ],
                          if (!_isShowAction) ...[
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ValueListenableBuilder(
                                valueListenable: _playerController,
                                builder:
                                    (context, VideoPlayerValue value, child) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: 10.w,
                                      bottom: 10.h,
                                      top: 2.h,
                                    ),
                                    child: Text(
                                      formatDuration(value.duration),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                            color: Colors.white,
                                            fontSize: 12.h,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return _videoLoading();
          },
        );
      }).toList(),
    );
  }

  Widget _videoLoading() {
    final maxWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth * 7 / 10,
        maxHeight: 440.h,
      ),
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: widget.isMsgOfUser ? Colors.black45 : Colors.black12,
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: LoadingMessage(
        isSender: widget.isMsgOfUser,
        theme: theme,
        content: AppLocalizations.of(context)!.loading_video,
        width: 240.w,
      ),
    );
  }

  Widget _pauseAndPlayButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          if (_playerController.value.isPlaying) {
            _playerController.pause();
          } else {
            _playerController.play();
          }
        });
      },
      icon: Icon(
        _playerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
        size: 36.h,
        color: Colors.white30,
      ),
    );
  }

  Widget _videoProgressBar() {
    return Column(
      children: [
        VideoProgressIndicator(
          colors: const VideoProgressColors(playedColor: Colors.white),
          _playerController,
          allowScrubbing: true,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
              valueListenable: _playerController,
              builder: (context, VideoPlayerValue value, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                    bottom: 10.h,
                    top: 2.h,
                  ),
                  child: Text(
                    formatDuration(value.position),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.white, fontSize: 12.h),
                  ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: _playerController,
              builder: (context, VideoPlayerValue value, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                    bottom: 10.h,
                    top: 2.h,
                  ),
                  child: Text(
                    formatDuration(value.duration),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.white, fontSize: 12.h),
                  ),
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
