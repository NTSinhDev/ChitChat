import 'package:chat_app/core/res/colors.dart';
import 'package:chat_app/core/res/spaces.dart';
import 'package:chat_app/models/models_injector.dart';
import 'package:chat_app/view_model/blocs/search/bloc_injector.dart';
import 'package:chat_app/view_model/blocs/search/search_bloc.dart';
import 'package:chat_app/views/chat/chat_screen.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

class ListUserWidget extends StatelessWidget {
  final ReplayStream<List<UserProfile>?> userListStream;

  const ListUserWidget({
    super.key,
    required this.userListStream,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<List<UserProfile>?>(
      stream: userListStream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              final listUser = snapshot.data!;
              return _buildListUser(maxHeight, listUser);
            } else {
              return const Text("Dont have any data match with keyword");
            }
          case ConnectionState.waiting:
          default:
            return Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(color: redAccent),
                  Spaces.h20,
                  const Text('Đang tải danh sách bạn bè'),
                ],
              ),
            );
        }
      },
    );
  }

  Widget _buildListUser(double maxHeight, List<UserProfile> listUser) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listUser.length,
        itemBuilder: (context, index) {
          final item = listUser[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: ListTile(
              onTap: () async {
                final searchBloc = context.read<SearchBloc>();
                // final createID = searchBloc.currentUser.profile?.id ?? '';
                // final userIDs = [createID, item.profile?.id ?? ''];
                // final usersSubject =
                //     userListStream as ReplaySubject<List<UserProfile>?>;
                // searchBloc.add(JoinConversationEvent(
                //   userIDs: userIDs,
                //   usersSubject: usersSubject,
                //   friend: item,
                // ));

                 await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (nContext) {
                        return ChatScreen(
                          currentUser: searchBloc.currentUser,
                          friendInfo: UserInformation(informations: item),
                        );
                      },
                      // ignore: prefer_const_constructors
                      settings: RouteSettings(
                        name: null,
                      ),
                    ),
                  );
              },
              leading: Container(
                padding: EdgeInsets.only(right: 8.w),
                child: StateAvatar(
                  urlImage: item.urlImage,
                  isStatus: false,
                  radius: 48.r,
                ),
              ),
              title: Text(
                item.profile?.fullName ?? 'UNKNOWN',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        },
      ),
    );
  }
}
