import 'package:chat_app/models/injector.dart';
import 'package:chat_app/utils/injector.dart';
import 'package:chat_app/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyMessageView extends StatelessWidget {
  final UserProfile friend;
  const EmptyMessageView({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.3,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Yay! A SnackBar!'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StateAvatar(
              urlImage: friend.urlImage,
              userId: friend.profile?.id ?? '',
              radius: 200.r,
            ),
            SizedBox(height: 20.h),
            Text(
              context.languagesExtension.empty_message,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: maxValueInteger,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
