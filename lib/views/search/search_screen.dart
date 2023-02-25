import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/view_model/providers/app_state_provider.dart';
import 'package:chat_app/widgets/list_user_widget.dart';
import 'package:chat_app/widgets/input_text_field_search.dart';
import 'package:chat_app/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  final List<dynamic>? listFriend;
  const SearchScreen({super.key, this.listFriend});

  @override
  Widget build(BuildContext context) {
    AppStateProvider appState = context.watch<AppStateProvider>();

    return WillPopScope(
      onWillPop: () async {
        context.read<ChatBloc>().add(ExitSearchEvent());
        return false;
      },
      child: Scaffold(
        appBar: _buildAppbar(appState.darkMode),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(
                  title: AppLocalizations.of(context)!.recommend,
                  isUpper: true,
                ),
                SizedBox(height: 20.h),
                // ListUserWidget(
                //   listUser: listFriend!,
                //   isAddFriend: false,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppbar(isDarkMode) {
    return AppBar(
      toolbarHeight: 72.h,
      leading: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<ChatBloc>().add(ExitSearchEvent());
            },
          );
        },
      ),
      title: TextFieldWidget(
        padding: 0,
        boxDecorationColor: isDarkMode ? blackDarkMode! : Colors.white,
        onChanged: (value) {},
        onDeleted: () {},
        onSubmitted: (value) {},
        suffixIconColor: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
