import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/image.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/blocs/chat/chat_bloc.dart';
import 'package:chat_app/views/chat/components/messages_module/components/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class MediaMessage extends StatelessWidget {
  final Message message;
  final bool isMsgOfUser;
  const MediaMessage({
    super.key,
    required this.message,
    required this.isMsgOfUser,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth * 7 / 10,
        ),
        margin: EdgeInsets.only(top: 8.h),
        child: Column(
          children: _buildMediaRows(context),
        ),
      ),
    );
  }

  List<Widget> _buildMediaRows(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    List<Widget> rows = [];
    int qty1 = message.listNameImage.length % 2;
    int qty2 = message.listNameImage.length;
    double rowsPty = (qty1 + qty2) / 2;
    int index = 0;
    for (var i = 0; i < rowsPty.toInt(); i++) {
      final condition = ((index + 1) > (message.listNameImage.length - 1));
      Row row = Row(
        children: [
          _buildItemGridView(
            chatBloc: chatBloc,
            index: index,
            alone: condition,
            oneFile: message.listNameImage.length == 1,
          ),
          if (!condition)
            _buildItemGridView(
              chatBloc: chatBloc,
              index: index + 1,
            ),
        ],
      );
      index += 2;
      rows.add(row);
    }
    return rows;
  }

  Widget _buildItemGridView({
    required ChatBloc chatBloc,
    required int index,
    bool? alone,
    bool? oneFile,
  }) {
    final mediaName = message.listNameImage.elementAt(index);
    final fileExtension = SplitUtilities.getFileExtension(fileName: mediaName);
    return StreamBuilder<String?>(
      stream: chatBloc.getFile(fileName: mediaName),
      builder: (context, fileSnapshot) {
        if (fileSnapshot.hasData) {
          if (fileExtension == 'jpg' || fileExtension == 'png') {
            return StreamBuilder<ui.Image>(
              stream: ImageUtilities.getRealSize(fileSnapshot.data ?? '')
                  .asStream(),
              builder: (context, sizeSnapshot) {
                if (sizeSnapshot.hasData) {
                  return ImageMessage(
                    isMsgOfUser: isMsgOfUser,
                    path: fileSnapshot.data ?? '',
                    isAlone: alone ?? false,
                    oneFile: oneFile ?? false,
                    imgInfo: sizeSnapshot.data,
                  );
                }
                return Container();
              },
            );
          }
          return VideoMessage(
            isMsgOfUser: isMsgOfUser,
            path: fileSnapshot.data ?? "",
          );
        }
        return Container();
      },
    );
  }
}
