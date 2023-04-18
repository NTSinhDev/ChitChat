import 'dart:developer';

import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/chat_screen.dart';
import 'package:chat_app/views/search/components/input_text_field_search.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'components/init_state_manager.dart';
import 'components/options_recommend.dart';
import 'components/user_search_list.dart';

class SearchScreen extends StatefulWidget {
  final Stream<List<UserProfile>> friendStream;
  const SearchScreen({super.key, required this.friendStream});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchBloc searchBloc;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return InitializeStateManager(
      stream: widget.friendStream,
      response: (bloc) {
        searchBloc = bloc;
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 72.h,
              title: SearchInputField(
                boxDecorationColor: theme ? AppColors.mdblack! : Colors.white,
                suffixIconColor: theme ? Colors.white : Colors.black,
                onChanged: onSearchUser,
                onDeleted: clearSeachBar,
              ),
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: BlocConsumer<SearchBloc, SearchState>(
                  listener: (context, state) async {
                    if (state is SearchInitialState) {
                      if (state.error != null) {
                        FlashMessageWidget(
                          context: context,
                          message: state.error!,
                          type: FlashMessageType.error,
                        );
                      }
                    }
                    if (state is JoinConversationState) {
                      await Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (nContext) {
                                return ChatScreen(
                                  conversation: state.conversation,
                                  currentUser: state.currentUser,
                                  friendInfo: state.friend,
                                );
                              },
                              settings: RouteSettings(
                                name: state.conversation == null
                                    ? null
                                    : "conversation:${state.conversation!.id}",
                              ),
                            ),
                          )
                          .then((value) =>
                              searchBloc.add(ComeBackSearchScreenEvent()));
                    }
                  },
                  builder: (context, state) {
                    if (state is SearchInitialState) {
                      return bodySearchScreenWidget(
                        showOptions: true,
                        label: context.languagesExtension.recommend,
                        listStream: state.friendsSubject,
                      );
                    }
                    if (state is SearchingState) {
                      return bodySearchScreenWidget(
                        label: context.languagesExtension.result,
                        listStream: state.usersSubject,
                        loading: state.loading,
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bodySearchScreenWidget({
    required String label,
    bool? showOptions,
    required ReplaySubject<List<UserProfile>?>? listStream,
    bool? loading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spaces.h20,
        if (showOptions ?? false) ...[
          const OptionsRecommend(),
          Spaces.h40,
        ],
        TitleWidget(title: label, isUpper: true),
        if (loading == null && listStream != null) ...[
          Spaces.h20,
          UserSearchList(userListStream: listStream),
        ] else ...[
          const Center(
            child: CircularProgressIndicator(color: AppColors.redAccent),
          )
        ]
      ],
    );
  }

  onSearchUser(String name) {
    EasyDebounce.cancel('addSearchingEvent');
    EasyDebounce.debounce(
      'addSearchingEvent',
      const Duration(milliseconds: 500),
      () => searchBloc.add(SearchingEvent(searchName: name)),
    );
  }

  clearSeachBar() {
    EasyDebounce.cancel('addSearchingEvent');
    searchBloc.add(SearchingEvent(searchName: ''));
  }
}
