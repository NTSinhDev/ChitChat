import 'dart:developer';

import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/core/res/spaces.dart';
import 'package:chat_app/view_model/providers/injector.dart';
import 'package:chat_app/views/chat/input_messages_module/components/emoji_widget.dart';
import 'package:chat_app/views/chat/input_messages_module/components/icon_action_widget.dart';
import 'package:chat_app/views/chat/input_messages_module/components/picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'components/input_messages_widget.dart';

class InputMessagesModule extends StatefulWidget {
  const InputMessagesModule({super.key});

  @override
  State<InputMessagesModule> createState() => _InputMessagesModuleState();
}

class _InputMessagesModuleState extends State<InputMessagesModule> {
  late bool isVisible;
  late bool emojiShowing;
  final inputController = TextEditingController();
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  List<Media> mediaList = []; // to save photos or videos have picked before
  bool isRecorderReady = false;
  bool isRecording = false;

  @override
  void initState() {
    isVisible = true;
    emojiShowing = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: theme ? blackDarkMode : Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(5, 5),
                blurRadius: 7,
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Button open camera
                IconActionWidget(
                  icon: Icons.camera_alt,
                  onTap: () => _openCamera(),
                  visible: isVisible,
                ),
                // Button open gallery
                IconActionWidget(
                  icon: CupertinoIcons.photo,
                  onTap: () => _openImagePicker(context),
                  visible: isVisible,
                ),
                // Button open record voice
                IconActionWidget(
                  icon: isRecording ? Icons.stop : Icons.mic,
                  onTap: () => _recordVoice(),
                  visible: isVisible,
                ),
                InputMessageWidget(
                  inputController: inputController,
                  onchange: _fullyExpand,
                  ontapInput: _hideEmoji,
                  ontapEmoji: _hideOrShowEmoji,
                  onSubmitted: _sendMessage,
                ),
                Spaces.w14,
                InkWell(
                  onTap: () => _sendMessage(inputController.text),
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
        EmojiWidget(
          controller: inputController,
          emojiShowing: emojiShowing,
        ),
      ],
    );
  }

  @override
  void dispose() {
    inputController.dispose();
    recorder.closeRecorder();
    super.dispose();
  }

  _fullyExpand(String message) => setState(() {
        isVisible = message.isNotEmpty ? false : true;
      });

  _hideEmoji() => setState(() => emojiShowing = false);

  _hideOrShowEmoji() {
    setState(() {
      emojiShowing = !emojiShowing;
    });
    FocusScope.of(context).unfocus();
  }

  // Methods
  _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => PickerWidget(
        onPick: (selectedList) => setState(() => mediaList = selectedList),
      ),
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
    // Provider.of<ChatBloc>(context, listen: false).add(
    //   SendFilesEvent(
    //     fileType: type,
    //     listPath: listPath,
    //     roomID: widget.idRoom,
    //     friendID: widget.idFriend,
    //   ),
    // );
  }

  _sendMessage(String message) {
    if (message.isNotEmpty) {
      // Provider.of<ChatBloc>(context, listen: false).add(
      //   SendMessageEvent(
      //     message: value,
      //     idRoom: widget.idRoom,
      //     friendID: widget.idFriend,
      //   ),
      // );
      setState(() {
        isVisible = !isVisible;
      });
      inputController.clear();
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
