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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

part 'components/picker_widget.dart';
part 'components/input_messages_widget.dart';
part 'components/emoji_widget.dart';
part 'components/icon_action_widget.dart';

class MessageInputModule extends StatefulWidget {
  const MessageInputModule({super.key});

  @override
  State<MessageInputModule> createState() => _MessageInputModuleState();
}

class _MessageInputModuleState extends State<MessageInputModule> {
  List<Media> mediaList = []; // to save photos or videos have picked before
  bool isRecorderReady = false;
  bool isRecording = false;
  final inputController = TextEditingController();
  late final ChatBloc chatBloc;
  late bool isVisible;
  late bool emojiShowing;
  late FlutterSoundRecorder recorder;

  @override
  void initState() {
    isVisible = true;
    emojiShowing = false;
    chatBloc = context.read<ChatBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: theme ? AppColors(theme: theme).themeMode : Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(5, 5),
                blurRadius: 7,
              )
            ],
          ),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                Spaces.w8,
                InputMessageWidget(
                  inputController: inputController,
                  onchange: _fullyExpand,
                  ontapInput: _hideEmoji,
                  ontapEmoji: _hideOrShowEmoji,
                  onSubmitted: _sendMessage,
                ),
                Spaces.w8,
                IconActionWidget(
                  icon: FontAwesomeIcons.paperPlane,
                  onTap: () => _sendMessage(inputController.text),
                  visible: true,
                ),
                // Container(
                //   margin: EdgeInsets.only(bottom: 14.h),
                //   child: InkWell(
                //     onTap: () => _sendMessage(inputController.text),
                //     child: FaIcon(
                //       FontAwesomeIcons.paperPlane,
                //       color: AppColors(theme: theme).iconTheme,
                //     ),
                //   ),
                // ),
                // Spaces.w8,
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
    try {
      recorder.closeRecorder();
      // ignore: empty_catches
    } catch (e) {}
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
          chatBloc.add(
            SendMessageEvent(
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
      chatBloc.add(
        SendMessageEvent(
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
    chatBloc.add(SendMessageEvent(message: message, type: MessageType.text));
    setState(() {
      isVisible = !isVisible;
    });
    inputController.clear();
  }

  Future _initRecorder() async {
    recorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      isRecorderReady = false;
    }
    await recorder.openRecorder();
    isRecorderReady = true;
  }

  Future _stop() async {
    final path = await recorder.stopRecorder();
    chatBloc.add(
      SendMessageEvent(
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
    try {
      await recorder.startRecorder(toFile: 'audio.aac');
    } catch (e) {
      log('💣 Lỗi khi thực hiện {_recording}\nChi tiết: $e');
    }
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
