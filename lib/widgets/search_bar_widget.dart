import 'package:chat_app/view_model/blocs/chat/bloc_injector.dart';
import 'package:chat_app/core/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatelessWidget {
  final bool theme;
  const SearchBar({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      margin: EdgeInsets.fromLTRB(
        14.w,
        0,
        14.w,
        0,
      ),
      decoration: BoxDecoration(
        color: theme ? darkGreyDarkMode : lightGreyLightMode,
        borderRadius: BorderRadius.circular(36.r),
      ),
      child: InkWell(
        onTap: () {
          context.read<ChatBloc>().add(InitLookingForChatEvent());
        },
        child: Row(
          children: [
            SizedBox(width: 14.w),
            Icon(
              CupertinoIcons.search,
              color: theme ? Colors.white : darkGreyDarkMode,
              size: 20.r,
            ),
            SizedBox(width: 14.w),
            Text(
              'Tìm kiếm',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: theme ? Colors.white : darkGreyDarkMode,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
