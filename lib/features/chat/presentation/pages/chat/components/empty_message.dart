import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/presentation/utils/constants.dart';
import 'package:chat_app/presentation/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyMessage extends StatelessWidget {
  final User friend;
  const EmptyMessage({super.key, required this.friend});

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
              avatar: friend.urlImage!,
              isStatus: false,
              radius: 200.r,
            ),
            SizedBox(height: 20.h),
            Text(
              AppLocalizations.of(context)!.empty_message,
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
