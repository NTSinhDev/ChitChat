import 'package:chat_app/core/res/spaces.dart';
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
        },
        child: Row(
          children: [
            Spaces.w14,
            Icon(
              CupertinoIcons.search,
              color: theme ? Colors.white : darkGreyDarkMode,
              size: 20.r,
            ),
            Spaces.w14,
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
