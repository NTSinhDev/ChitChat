import 'package:chat_app/core/res/spaces.dart';
import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/widgets/list_user_widget.dart';
import 'package:chat_app/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListSearchUsers extends StatelessWidget {
  const ListSearchUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          title: AppLocalizations.of(context)!.result,
          isUpper: true,
        ),
        Spaces.h20,
        BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is LookingForFriendState) {
              if (state.finding!) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.failed!) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.not_found_user),
                );
              }
              if (state.cuccessed! && state.user != null) {
                return Container();
                // return ListUserWidget(
                //   listUser: [state.user!],
                //   isAddFriend: true,
                //   loadding: state.addFriendloading ?? false,
                //   success: state.addFriendSuccess ?? false,
                // );
              }
            }
            return Center(
              child: Text(AppLocalizations.of(context)!.error_connect),
            );
          },
        ),
      ],
    );
  }
}
