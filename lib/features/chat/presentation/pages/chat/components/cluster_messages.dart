import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/features/chat/presentation/pages/chat/components/message_item.dart';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:chat_app/presentation/utils/functions.dart';
import 'package:chat_app/presentation/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClusterMessages extends StatefulWidget {
  final String avatarFriend;
  final bool theme;
  final bool isSender;
  final List<dynamic> messages;
  final bool isLastCluster;
  const ClusterMessages({
    super.key,
    required this.theme,
    required this.isSender,
    required this.messages,
    required this.avatarFriend,
    required this.isLastCluster,
  });

  @override
  State<ClusterMessages> createState() => _ClusterMessagesState();
}

class _ClusterMessagesState extends State<ClusterMessages> {
  late bool _loading;
  late bool _sended;
  late bool _seen;

  @override
  void initState() {
    _loading = false;
    _sended = false;
    _seen = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // size
    final width4 = SizedBox(width: 4.w);
    final height4 = SizedBox(height: 4.h);

    int currentIndex = 0;
    final timeMessageItem = Message.fromJson(widget.messages.last).time;

    return Padding(
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 10.h,
      ),
      child: Row(
        mainAxisAlignment:
            widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: widget.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: widget.isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: widget.messages.map((item) {
                  if (widget.isLastCluster) {
                    setState(() {
                      currentIndex++;
                    });
                    _changeStateLastMsg(currentIndex);
                  }
                  final msg = Message.fromJson(item);
                  return MessageItem(
                    message: msg,
                    theme: widget.theme,
                    isSender: widget.isSender,
                  );
                }).toList(),
              ),
              height4,
              Row(
                children: [
                  Text(
                    formatTime(timeMessageItem),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: lightGreyDarkMode),
                  ),
                  if (_sended && widget.isSender) ...[
                    width4,
                    const Icon(
                      Icons.check,
                      size: 16,
                      color: darkGreyLightMode,
                    ),
                  ],
                  if (_loading && widget.isSender) ...[
                    width4,
                    SizedBox(
                      height: 12.h,
                      width: 12.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 1.3,
                        color: darkGreyLightMode,
                      ),
                    ),
                  ],
                ],
              ),
              if (_seen && widget.isSender) ...[
                height4,
                StateAvatar(
                  avatar: widget.avatarFriend,
                  isStatus: false,
                  radius: 16.r,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  _changeStateLastMsg(index) {
    if (index == widget.messages.length) {
      _loading = false;
      _sended = false;
      _seen = false;
      final stateLastMsg = Message.fromJson(widget.messages.last).state;
      if (stateLastMsg == 'viewed') {
        setState(() {
          _seen = true;
        });
      } else if (stateLastMsg == 'loading') {
        setState(() {
          _loading = true;
        });
      } else if (stateLastMsg == 'sended') {
        setState(() {
          _sended = true;
        });
      }
    }
  }
}
