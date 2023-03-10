import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/models/url_image.dart';
import 'package:chat_app/res/colors.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClusterMessages extends StatefulWidget {
  final bool isSender;
  final List<dynamic> messages;
  final bool isLastCluster;
  const ClusterMessages({
    super.key,
    required this.isSender,
    required this.messages,
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
    int currentIndex = 0;
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
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
                  return Container();
                  // final msg = Message.fromJson(item);
                  // return MessageItem(
                  //   message: msg,
                  //   theme: widget.theme,
                  //   isSender: widget.isSender,
                  // );
                }).toList(),
              ),
              Spaces.h4,
              // _clusterMsgInfo(),
              // ..._seenMessageWidget(),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _seenMessageWidget() {
    if (_seen && widget.isSender) {
      return [
        Spaces.h4,
        StateAvatar(
          urlImage: URLImage(),
          userId: '',
          radius: 16.r,
        ),
      ];
    }
    return [];
  }

  Widget _clusterMsgInfo() {
    return Row(
      children: [
        // _clusterTime(context),
        // ..._clusterMsgState(),
        if (_loading && widget.isSender) ...[
          Spaces.w4,
          SizedBox(
            height: 12.h,
            width: 12.w,
            child: CircularProgressIndicator(
              strokeWidth: 1.3,
              color: ResColors.darkGrey(isDarkmode: false),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _clusterMsgState() {
    if (_sended && widget.isSender) {
      return [
        Spaces.w4,
        Icon(
          Icons.check,
          size: 16,
          color: ResColors.darkGrey(isDarkmode: false),
        ),
      ];
    }
    return [];
  }

  Widget _clusterTime(BuildContext context) {
    return Text(
      // formatTime(timeMessageItem)
      '',
      style: Theme.of(context)
          .textTheme
          .labelSmall!
          .copyWith(color: ResColors.lightGrey(isDarkmode: true)),
    );
  }

  _changeStateLastMsg(index) {
    if (index == widget.messages.length) {
      _loading = false;
      _sended = false;
      _seen = false;
      // final stateLastMsg = Message.fromJson(widget.messages.last).state;
      // if (stateLastMsg == 'viewed') {
      //   setState(() {
      //     _seen = true;
      //   });
      // } else if (stateLastMsg == 'loading') {
      //   setState(() {
      //     _loading = true;
      //   });
      // } else if (stateLastMsg == 'sended') {
      //   setState(() {
      //     _sended = true;
      //   });
      // }
    }
  }
}
