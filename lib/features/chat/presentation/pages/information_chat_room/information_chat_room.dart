import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/presentation/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationChatRoomScreen extends StatelessWidget {
  final User friend;
  const InformationChatRoomScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    // Size
    final sizedBox24 = SizedBox(height: 24.h);
    final sizedBox50 = SizedBox(height: 50.h);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sizedBox24,
            Center(
              child: StateAvatar(
                avatar: friend.urlImage!,
                isStatus: false,
                radius: 200.r,
              ),
            ),
            sizedBox24,
            Text(
              friend.name!,
              maxLines: 4,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                shadows: [
                  const BoxShadow(
                    color: Colors.black12,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            sizedBox50,
          ],
        ),
      ),
    );
  }
}
