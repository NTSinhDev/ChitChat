import 'package:chat_app/features/chat/presentation/bloc/bloc.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
import 'package:chat_app/core/utils/functions.dart';
import 'package:chat_app/presentation/widgets/new_list_chat_room.dart';
import 'package:chat_app/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helpers/error/no_internet.dart';
import 'components/list_online_user.dart';
import 'package:socket_io_client/socket_io_client.dart'
    as IO; // ignore: library_prefixes

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = context.watch<AppStateProvider>();
    final listFriend = context.watch<ChatBloc>().listFriend;
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 14.h),
      physics: const BouncingScrollPhysics(),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state is JoinAppState) ...[
                if (!appState.hasConnect) ...[
                  const NoInternetText(),
                ],
                SearchBar(theme: appState.darkMode),
                // ListOnlineUser(listFriend: sortListUserToOnlState(listFriend!)),
                if (state.listRoom.isNotEmpty) ...[
                  // NewListChatRoom(
                  //   listRoom: sortListRoomToLastestTime(state.listRoom),
                  //   isGroup: false,
                  // ),
                ],
                
              ],
            ],
          );
        },
      ),
    );
  }
}
