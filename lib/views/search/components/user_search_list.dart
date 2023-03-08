import 'package:chat_app/models/injector.dart';
import 'package:chat_app/res/injector.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/search/components/user_search_item.dart';
import 'package:chat_app/widgets/widget_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

class UserSearchList extends StatelessWidget {
  final ReplayStream<List<UserProfile>?> userListStream;

  const UserSearchList({
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
              return Container(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listUser.length,
                  itemBuilder: (context, index) =>
                      UserSearchItem(user: listUser[index]),
                ),
              );
            }
            return const Text("Dont have any data match with keyword");
          case ConnectionState.waiting:
          default:
            return Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(color: ResColors.redAccent),
                  Spaces.h20,
                  const Text('Đang tải danh sách bạn bè'),
                ],
              ),
            );
        }
      },
    );
  }
}
