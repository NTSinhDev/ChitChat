part of '../input_messages_module.dart';

class PickerWidget extends StatefulWidget {
  final Function(List<Media>) onPick;
  final Function() sendFiles;
  const PickerWidget(
      {super.key, required this.onPick, required this.sendFiles});

  @override
  State<PickerWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  List<Media> mediaList = []; // to save photos or videos have picked before

  @override
  Widget build(BuildContext context) {
    return MediaPicker(
      mediaList: mediaList,
      onPick: (selectedList) => onSubmitAfterPicked(selectedList, context),
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

  onSubmitAfterPicked(List<Media> selectedList, context) {
    widget.onPick(selectedList);
    widget.sendFiles;
    

    Navigator.pop(context);
  }
}
