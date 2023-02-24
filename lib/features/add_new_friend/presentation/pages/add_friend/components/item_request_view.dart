import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/features/chat/presentation/bloc/bloc.dart';
import 'package:chat_app/presentation/res/colors.dart';
import 'package:chat_app/presentation/utils/functions.dart';
import 'package:chat_app/presentation/widgets/custom_button_widget.dart';
import 'package:chat_app/presentation/widgets/state_avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ItemRequestView extends StatelessWidget {
  final User user;
  final String time;
  final int index;
  const ItemRequestView({
    super.key,
    required this.user,
    required this.time,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 30.h,
        left: 12.w,
      ),
      constraints: BoxConstraints(maxHeight: 120.h),
      height: 96.h,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          StateAvatar(
            avatar: user.urlImage ?? '',
            isStatus: false,
            radius: 68.r,
          ),
          SizedBox(width: 20.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 250.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatName(name: user.name!),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      formatDay(time),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBtnWidget(
                    title: AppLocalizations.of(context)!.accept,
                    onPressed: () {
                      Provider.of<ChatBloc>(context, listen: false).add(
                        AcceptFriendRequestEvent(
                          friendID: user.sId!,
                          index: index,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  CustomBtnWidget(
                    title: AppLocalizations.of(context)!.delete,
                    onPressed: () {
                      Provider.of<ChatBloc>(context, listen: false).add(
                        RemoveFriendRequest(
                          friendID: user.sId!,
                        ),
                      );
                    },
                    backgroundColor: darkGreyLightMode,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
