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
  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.watch<ConversationBloc>();
    return ListTile(
      onTap: () async => await _navigateToChatScreen(
        context,
        conversationBloc,
        widget.friendProfile,
      ),
      leading: StateAvatar(
        urlImage: widget.friendProfile.urlImage,
        userId: _handleUserIdForStateAvatarWidget(
          widget.friendProfile.profile?.id,
          conversationBloc,
        ),
        radius: 56.r,
      ),
      title: Container(
        margin: EdgeInsets.only(bottom: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _conversationNameWidget(context),
            _timeLastMsgWidget(context, conversationBloc),
          ],
        ),
      ),
      subtitle: Text(
        _handleMessageContent(
          context,
          conversationBloc.currentUser.profile!.id!,
          widget.friendProfile.profile?.id ?? '',
        ),
        overflow: TextOverflow.ellipsis,
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 13.r),
      ),
    );
  }

  // Wigets
  Widget _timeLastMsgWidget(BuildContext context, ConversationBloc bloc) {
    final locale = context.watch<LanguageProvider>().locale;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          TimeUtilities.formatTime(
            widget.conversation.stampTimeLastText,
            locale,
          ),
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(fontSize: 12, color: Colors.grey[700]),
        ),
        if (!_isRead(context, bloc.currentUser.profile!.id!)) ...[
          Spaces.w12,
          const Badge(
            alignment: AlignmentDirectional.centerEnd,
            backgroundColor: Color(0xff75AAF0),
          ),
        ]
      ],
    );
  }

  Widget _conversationNameWidget(BuildContext context) {
    final isDarkmode = context.watch<ThemeProvider>().isDarkMode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.friendProfile.profile?.fullName ?? "",
          style:
              Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14.r),
        ),
        if (widget.friendProfile.profile != null &&
            widget.friendProfile.profile!.email == 'Virtual') ...[
          Spaces.w4,
          Container(
            padding: EdgeInsets.all(2.h),
            decoration: BoxDecoration(
              color: ResColors.backgroundLightPurple,
              boxShadow: [
                if (!isDarkmode)
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
  String _handleUserIdForStateAvatarWidget(String? id, ConversationBloc bloc) {
    if (id == null || id.isEmpty || id == bloc.currentUser.profile!.id!) {
      return '';
    }
    return id;
  }

  _navigateToChatScreen(
    BuildContext context,
    ConversationBloc conversationBloc,
    UserProfile? userProfile,
  ) async {
    if (userProfile == null) return;
    if (!_isRead(context, conversationBloc.currentUser.profile!.id!)) {
      conversationBloc
          .add(ReadConversationEvent(conversation: widget.conversation));
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (nContext) {
          return ChatScreen(
            conversation: widget.conversation,
            currentUser: conversationBloc.currentUser,
            friendInfo: userProfile,
          );
        },
        settings: RouteSettings(
          name: "conversation:${widget.conversation.id}",
        ),
      ),
    );
  }

  bool _isRead(BuildContext context, String id) {
    if (widget.conversation.readByUsers.contains(id)) {
      return true;
    }
    return false;
  }

  String _handleMessageContent(
    BuildContext context,
    String currentId,
    String conversationUserId,
  ) =>
      widget.conversation.listUser.first == currentId
          ? "${context.languagesExtension.you}: ${widget.conversation.lastMessage}"
          : widget.conversation.lastMessage;
}
