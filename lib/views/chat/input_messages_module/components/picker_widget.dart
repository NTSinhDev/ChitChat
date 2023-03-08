import 'package:flutter/material.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PickerWidget extends StatefulWidget {
  final Function(List<Media>) onPick;
  const PickerWidget({super.key, required this.onPick});

  @override
  State<PickerWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  List<Media> mediaList = []; // to save photos or videos have picked before

  @override
  Widget build(BuildContext context) {
    return MediaPicker(
      mediaList: mediaList,
      onPick: (selectedList) => _onSubmitAfterPicked(selectedList),
      onCancel: () => Navigator.pop(context),
      mediaCount: MediaCount.multiple,
      mediaType: MediaType.all,
      decoration: PickerDecoration(
        actionBarPosition: ActionBarPosition.top,
        blurStrength: 2,
        completeText: AppLocalizations.of(context)!.send,
      ),
    );
  }

  _onSubmitAfterPicked(List<Media> selectedList) {
    widget.onPick(selectedList); // update media list

    List<String> imgPathList = []; // paths of imgs were picked
    List<String> videoPathList = []; // paths of videos were picked
    for (var selected in selectedList) {
      if (selected.mediaType == MediaType.image) {
        imgPathList.add(selected.file!.path); // get img path
      } else if (selected.mediaType == MediaType.video) {
        videoPathList.add(selected.file!.path); // get img path
      }
    }
    // send imgs
    if (imgPathList.isNotEmpty) {
      _sendFiles(imgPathList, 'image'); // pass for bloc model
    }
    // send videos
    if (videoPathList.isNotEmpty) {
      _sendFiles(videoPathList, 'video'); // pass for bloc model
    }

    Navigator.pop(context);
  }

  _sendFiles(List<String> listPath, String type) {
    // Provider.of<ChatBloc>(context, listen: false).add(
    //   SendFilesEvent(
    //     fileType: type,
    //     listPath: listPath,
    //     roomID: widget.idRoom,
    //     friendID: widget.idFriend,
    //   ),
    // );
  }
}
