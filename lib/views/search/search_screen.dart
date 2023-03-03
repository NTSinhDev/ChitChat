import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/models/models_injector.dart';
import 'package:chat_app/view_model/blocs/search/bloc_injector.dart';
import 'package:chat_app/view_model/providers/injector.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
    Provider.of<SearchBloc>(context, listen: false).add(SearchingEvent(
      searchName: '',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().isDarkMode;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72.h,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          title: InputFieldWidget(
            padding: 0,
            boxDecorationColor: theme ? blackDarkMode! : Colors.white,
            suffixIconColor: theme ? Colors.white : Colors.black,
            onChanged: (name) => _onSearchUser(name, context),
            onDeleted: () => Provider.of<SearchBloc>(
              context,
              listen: false,
            ).add(
              SearchingEvent(
                searchName: '',
              ),
            ),
            onSubmitted: (string) {},
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitialState) {
                  return _bodySearchScreenWidget(
                    label: AppLocalizations.of(context)!.recommend,
                    listStream: state.friendsSubject,
                  );
                }
                if (state is SearchingState) {
                  return _bodySearchScreenWidget(
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

  Widget _bodySearchScreenWidget({
    required String label,
    required ReplaySubject<List<UserProfile>?>? listStream,
    bool? loading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(title: label, isUpper: true),
        if (loading == null && listStream != null) ...[
          SizedBox(height: 20.h),
          ListUserWidget(userListStream: listStream),
        ] else ...[
          const Center(
            child: CircularProgressIndicator(color: redAccent),
          )
        ]
      ],
    );
  }

  _onSearchUser(String name, BuildContext context) {
    EasyDebounce.cancel('addSearchingEvent');
    EasyDebounce.debounce(
      'addSearchingEvent',
      const Duration(milliseconds: 200),
      () => context.read<SearchBloc>().add(SearchingEvent(searchName: name)),
    );
  }
}
