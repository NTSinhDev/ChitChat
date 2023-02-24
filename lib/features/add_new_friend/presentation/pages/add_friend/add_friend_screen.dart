import 'package:chat_app/features/chat/presentation/bloc/bloc.dart';
import 'package:chat_app/features/add_new_friend/presentation/pages/add_friend/components/list_search.dart';
import 'package:chat_app/features/add_new_friend/presentation/pages/add_friend/components/friend_requests.dart';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:chat_app/presentation/services/app_state_provider/app_state_provider.dart';
import 'package:chat_app/presentation/widgets/input_text_field_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  @override
  Widget build(BuildContext context) {
    //* app states
    AppStateProvider appState = context.watch<AppStateProvider>();
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ChatBloc>(context, listen: false).add(ExitFriendEvent());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72.h,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Provider.of<ChatBloc>(context, listen: false)
                  .add(ExitFriendEvent());
            },
          ),
          title: TextFieldWidget(
            hintText: AppLocalizations.of(context)!.input_email,
            padding: 0,
            boxDecorationColor:
                appState.darkMode ? blackDarkMode! : Colors.white,
            onChanged: (value) {},
            onDeleted: _onDelete,
            onSubmitted: (value) {
              FocusScope.of(context).unfocus();
              Provider.of<ChatBloc>(context, listen: false).add(
                FindUserEvent(email: value),
              );
            },
            suffixIconColor: appState.darkMode ? Colors.white : Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(14.h) ,
          child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
            return Center(
              child: state is LookingForFriendState && state.init!
                  ? FriendRequestView(
                      friendRequests: state.requests!,
                    )
                  : const ListSearchUsers(),
            );
          }),
        ),
      ),
    );
  }

  _onDelete() {
    FocusScope.of(context).unfocus();
    Provider.of<ChatBloc>(context, listen: false).add(
      BackToFriendRequestEvent(),
    );
  }
}
