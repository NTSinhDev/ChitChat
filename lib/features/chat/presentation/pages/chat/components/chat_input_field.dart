import 'dart:developer';
import 'dart:io';

import 'package:chat_app/features/chat/presentation/bloc/bloc.dart';
import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controllerChat;
  final String idRoom;
  final String idFriend;
  const ChatInputField({
    super.key,
    required this.controllerChat,
    required this.idRoom,
    required this.idFriend,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late bool isVisibility;
  late bool emojiShowing;
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  List<Media> mediaList = []; // to save photos or videos have picked before
  bool isRecorderReady = false;
  bool isRecording = false;

  @override
  void initState() {
    isVisibility = true;
    emojiShowing = false;
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = context.watch<AppStateProvider>();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h,
          ),
          decoration: _decorationBox(appState),
          child: SafeArea(
            child: Row(
              children: [
                // Button open camera
                _actionIcon(
                  Icons.camera_alt,
                  () => _openCamera(),
                ),
                // Button open gallery
                _actionIcon(
                  CupertinoIcons.photo,
                  () => _openImagePicker(context),
                ),
                // Button open record voice
                _actionIcon(
                  isRecording ? Icons.stop : Icons.mic,
                  () => _recordVoice(),
                ),
                _inputMessage(
                  appState.darkMode,
                  _onChangeInputMessage,
                  context,
                ),
                SizedBox(width: 14.w),
                InkWell(
                  onTap: () => _sendMessage(widget.controllerChat.text),
                  child: Icon(
                    Icons.send_rounded,
                    size: 28.h,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        _emojiWidget(),
      ],
    );
  }

  // Widgets
  Widget _emojiWidget() {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
          height: 280.h,
          child: EmojiPicker(
            textEditingController: widget.controllerChat,
            config: Config(
              columns: 7,
              emojiSizeMax:
                  32 * (!foundation.kIsWeb && Platform.isIOS ? 1.30 : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              backspaceColor: Colors.blue,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              showRecentsTab: true,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              noRecents: Text(
                AppLocalizations.of(context)!.no_recents,
                style: TextStyle(fontSize: 20.h, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: const SizedBox.shrink(),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
              checkPlatformCompatibility: true,
            ),
          )),
    );
  }

  Widget _actionIcon(IconData icon, Function()? onTap) {
    return Visibility(
      visible: isVisibility,
      child: Container(
        padding: EdgeInsets.only(right: 14.w),
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            size: 28.r,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  BoxDecoration _decorationBox(AppStateProvider appState) {
    return BoxDecoration(
      color: appState.darkMode ? blackDarkMode : Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          offset: Offset(5, 5),
          blurRadius: 7,
        ),
      ],
    );
  }

  Widget _inputMessage(bool theme, onchange, BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: theme ? darkGreyDarkMode : lightGreyLightMode100,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 16.w),
            Expanded(
              child: TextField(
                maxLines: 6,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                onTap: () => setState(() => emojiShowing = false),
                style: Theme.of(context).textTheme.displaySmall,
                controller: widget.controllerChat,
                onSubmitted: (value) => _sendMessage(value),
                onChanged: (value) => onchange(value),
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: theme ? Colors.white : darkGreyLightMode,
                      ),
                  border: InputBorder.none,
                  hintText:  AppLocalizations.of(context)!.inbox,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            InkWell(
              onTap: () {
                setState(() {
                  emojiShowing = !emojiShowing;
                });
                FocusScope.of(context).unfocus();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 6.w, 12.h),
                child: const Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickerWidget(BuildContext context) {
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

  // Methods
  _onSubmitAfterPicked(List<Media> selectedList) {
    setState(() => mediaList = selectedList); // update media list

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

  _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _pickerWidget(context),
    );
  }

  Future _openCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      _sendFiles([image.path], 'image');
    } on PlatformException catch (e) {
      log('Pick image failed: $e');
    }
  }

  _sendFiles(List<String> listPath, String type) {
    Provider.of<ChatBloc>(context, listen: false).add(
      SendFilesEvent(
        fileType: type,
        listPath: listPath,
        roomID: widget.idRoom,
        friendID: widget.idFriend,
      ),
    );
  }

  _sendMessage(String value) {
    if (value.isNotEmpty) {
      Provider.of<ChatBloc>(context, listen: false).add(
        SendMessageEvent(
          message: value,
          idRoom: widget.idRoom,
          friendID: widget.idFriend,
        ),
      );
      setState(() {
        isVisibility = !isVisibility;
      });
      widget.controllerChat.clear();
    }
  }

  _onChangeInputMessage(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isVisibility = false;
      });
    } else {
      setState(() {
        isVisibility = true;
      });
    }
  }

  Future _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      isRecorderReady = false;
    }
    await recorder.openRecorder();
    isRecorderReady = true;
  }

  Future _stop() async {
    final path = await recorder.stopRecorder();
    _sendFiles([path!], 'audio');
    setState(() {
      isRecording = false;
    });
  }

  Future _recording() async {
    setState(() {
      isRecording = true;
    });
    await recorder.startRecorder(toFile: 'audio.aac');
  }

  _recordVoice() async {
    await _initRecorder();
    if (!isRecorderReady) return;

    if (isRecording) {
      await _stop();
    } else {
      await _recording();
    }
  }
}
