import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/chat/chat_screen.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  final List<UserInformation>? listFriend;
  final UserProfile currentUser;
  const SearchScreen({
    super.key,
    this.listFriend,
    required this.currentUser,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchBloc searchBloc;
  @override
  void initState() {
    super.initState();
    searchBloc = context.read<SearchBloc>();
    searchBloc.add(SearchingEvent(searchName: ''));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return WillPopScope(
      onWillPop: () async {
        exitSearchScreen(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72.h,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => exitSearchScreen(context),
          ),
          title: InputFieldWidget(
            padding: 0,
            boxDecorationColor: theme ? blackDarkMode! : Colors.white,
            suffixIconColor: theme ? Colors.white : Colors.black,
            onChanged: onSearchUser,
            onDeleted: clearSeachBar,
            onSubmitted: startSearching,
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocConsumer<SearchBloc, SearchState>(
              listener: (context, state) async {
                if (state is SearchInitialState) {
                  if (state.error != null) {
                    FlashMessage(
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
                    label: AppLocalizations.of(context)!.recommend,
                    listStream: state.friendsSubject,
                  );
                }
                if (state is SearchingState) {
                  return bodySearchScreenWidget(
                    label: AppLocalizations.of(context)!.result,
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
  }

  Widget bodySearchScreenWidget({
    required String label,
    required ReplaySubject<List<UserProfile>?>? listStream,
    bool? loading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: label, isUpper: true),
        if (loading == null && listStream != null) ...[
          Spaces.h20,
          ListUserWidget(userListStream: listStream),
        ] else ...[
          const Center(
            child: CircularProgressIndicator(color: redAccent),
          )
        ]
      ],
    );
  }

  exitSearchScreen(BuildContext context) {
    Navigator.pop(context);
    // Todo: exit search screen here
  }

  onSearchUser(String name) {
    EasyDebounce.cancel('addSearchingEvent');
    EasyDebounce.debounce(
      'addSearchingEvent',
      const Duration(milliseconds: 200),
      () => searchBloc.add(SearchingEvent(searchName: name)),
    );
  }

  startSearching(String name) =>
      searchBloc.add(SearchingEvent(searchName: name));

  clearSeachBar() => searchBloc.add(SearchingEvent(searchName: ''));
}
