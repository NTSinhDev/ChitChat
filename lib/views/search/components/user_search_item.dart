import 'package:chat_app/models/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserSearchItem extends StatelessWidget {
  final UserProfile user;
  const UserSearchItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        onTap: () => _joinConversation(searchBloc),
        leading: SizedBox(
          width: 52.w,
          child: StateAvatar(
            urlImage: user.urlImage,
            userId: user.profile!.id!,
            radius: 52.r,
          ),
        ),
        title: Text(
          user.profile?.fullName ?? 'UNKNOWN',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  _joinConversation(SearchBloc searchBloc) {
    final createID = searchBloc.currentUser.profile?.id ?? '';
    final userIDs = [createID, user.profile?.id ?? ''];
    searchBloc.add(JoinConversationEvent(
      userIDs: userIDs,
      friend: user,
    ));
  }
}
