import 'dart:developer';
import 'dart:io';

import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

part 'components/picker_widget.dart';
part 'components/input_messages_widget.dart';
part 'components/emoji_widget.dart';
part 'components/icon_action_widget.dart';

class InputMessagesModule extends StatefulWidget {
  const InputMessagesModule({super.key});

  @override
  State<InputMessagesModule> createState() => _InputMessagesModuleState();
}

class _InputMessagesModuleState extends State<InputMessagesModule> {
  late bool isVisible;
  late bool emojiShowing;
  late final ChatBloc chatBloc;
  final inputController = TextEditingController();
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  List<Media> mediaList = []; // to save photos or videos have picked before
  bool isRecorderReady = false;
  bool isRecording = false;

  @override
  void initState() {
    isVisible = true;
    emojiShowing = false;
    chatBloc = Provider.of(context, listen: false);
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
            color: theme ? ResColors.mdblack : Colors.white,
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
                IconActionWidget(
                  icon: Icons.camera_alt,
                  onTap: () => _openCamera(),
                  visible: isVisible,
                ),
                IconActionWidget(
                  icon: CupertinoIcons.photo,
                  onTap: () => _openImagePicker(context),
                  visible: isVisible,
                ),
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
      builder: (nContext) => PickerWidget(
        onPick: (selectedList) {
          setState(() => mediaList = selectedList);
          Provider.of<ChatBloc>(context, listen: false).add(
            SendFilesEvent(
              files: mediaList.map((media) => media.file!.path).toList(),
              type: MessageType.media,
            ),
          );
        },
        sendFiles: () {
          log('🚀log⚡');
        },
      ),
    );
  }

  Future _openCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      if (!mounted) return;
      Provider.of<ChatBloc>(context, listen: false).add(
        SendFilesEvent(
          files: [image.path],
          type: MessageType.media,
        ),
      );
    } on PlatformException catch (e) {
      log('Pick image failed: $e');
    }
  }

  _sendMessage(String message) {
    if (message.isEmpty) return;
    chatBloc.add(SendMessageEvent(message: message));
    setState(() {
      isVisible = !isVisible;
    });
    inputController.clear();
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
    Provider.of<ChatBloc>(context, listen: false).add(
      SendFilesEvent(
        files: path != null ? [path] : [],
        type: MessageType.audio,
      ),
    );
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
