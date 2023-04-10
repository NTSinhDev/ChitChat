import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConversationItem extends StatefulWidget {
  final Conversation conversation;
  final UserProfile friendProfile;
  const ConversationItem({
    super.key,
    required this.conversation,
    required this.friendProfile,
  });

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  bool isReadMsg = false;

  late final ConversationBloc conversationBloc;
  late final ThemeProvider theme;
  late final LanguageProvider lang;
  @override
  void initState() {
    super.initState();
    conversationBloc = context.read<ConversationBloc>();
    theme = context.read<ThemeProvider>();
    lang = context.read<LanguageProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async => await ontapConversation(context),
      leading: StateAvatar(
        urlImage: widget.friendProfile.urlImage,
        userId: handleUserId(widget.friendProfile.profile?.id),
        radius: 56.r,
      ),
      title: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            conversationName(context),
            timeAndNotidyRead(context),
          ],
        ),
      ),
      subtitle: _messageWidget(context),
    );
  }

  // Wigets
  Text _messageWidget(BuildContext context) {
    final messageContent = widget.conversation.listUser.first ==
            conversationBloc.currentUser.profile!.id!
        ? "${context.languagesExtension.you}: ${widget.conversation.lastMessage}"
        : widget.conversation.lastMessage;
    return Text(
      messageContent,
      overflow: TextOverflow.ellipsis,
      maxLines: textMaxLines(context),
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontSize: 12.r,
            fontWeight: textFontWeight(context),
            color: textColor(context) ?? Colors.grey[500],
          ),
    );
  }

  Widget timeAndNotidyRead(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          TimeUtilities.formatTime(
            widget.conversation.stampTimeLastText,
            lang.locale,
          ),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 12.r,
                color: textColor(context) ?? Colors.grey[700],
                fontWeight: textFontWeight(context),
              ),
        ),
        // Notify if have not read yet
        if (!isRead(context, conversationBloc.currentUser.profile!.id!)) ...[
          Spaces.w12,
          const Badge(
            alignment: AlignmentDirectional.centerEnd,
            backgroundColor: Color(0xff75AAF0),
          ),
        ]
      ],
    );
  }

  Widget conversationName(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.friendProfile.profile?.fullName ?? "",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 14.r,
                fontWeight: textFontWeight(context),
              ),
        ),
        if (widget.friendProfile.profile != null &&
            widget.friendProfile.profile!.email == 'Virtual') ...[
          Spaces.w4,
          Container(
            padding: EdgeInsets.all(2.h),
            decoration: BoxDecoration(
              color: ResColors.backgroundLightPurple,
              boxShadow: [
                if (!theme.isDarkMode)
                  const BoxShadow(
                    color: ResColors.customNewDarkPurple,
                    offset: Offset(1, 1),
                    blurRadius: 1,
                  )
              ],
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'Ảo',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 8.5.r,
                    color: ResColors.customNewDarkPurple,
                  ),
            ),
          ),
        ]
      ],
    );
  }

  // Functions
  Color? textColor(BuildContext context) {
    if (!isRead(context, conversationBloc.currentUser.profile!.id!)) {
      return theme.isDarkMode ? Colors.white : Colors.black;
    }
    return null;
  }

  FontWeight? textFontWeight(BuildContext context) {
    if (!isRead(context, conversationBloc.currentUser.profile!.id!)) {
      return FontWeight.bold;
    }
    return null;
  }

  int? textMaxLines(BuildContext context) {
    if (!isRead(context, conversationBloc.currentUser.profile!.id!)) {
      return 3;
    }
    return null;
  }

  Future ontapConversation(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (nContext) {
          return ChatScreen(
            conversation: widget.conversation,
            currentUser: conversationBloc.currentUser,
            friendInfo: widget.friendProfile,
          );
        },
        settings: RouteSettings(
          name: "conversation:${widget.conversation.id}",
        ),
      ),
    );

    if (!mounted) return;
    if (!isRead(context, conversationBloc.currentUser.profile!.id!)) {
      conversationBloc
          .add(ReadConversationEvent(conversation: widget.conversation));
      setState(() {
        isReadMsg = true;
      });
    }
  }

  String handleUserId(String? id) {
    if (id == null ||
        id.isEmpty ||
        id == conversationBloc.currentUser.profile!.id!) {
      return '';
    }
    return id;
  }

  bool isRead(BuildContext context, String id) {
    if (isReadMsg || widget.conversation.readByUsers.contains(id)) {
      return true;
    }
    return false;
  }
}
