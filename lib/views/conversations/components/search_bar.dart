import 'package:chat_app/res/dimens.dart';
import 'package:chat_app/res/colors.dart';
import 'package:chat_app/view_model/injector.dart';
import 'package:chat_app/views/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/utils/injector.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final conversationBloc = context.watch<ConversationBloc>();
    // setup UI
    final theme = context.watch<ThemeProvider>().isDarkMode;
    final Color bgColor = theme
        ? ResColors.darkGrey(isDarkmode: theme)
        : ResColors.lightGrey(isDarkmode: theme);
    final Color contentColor =
        theme ? Colors.white : ResColors.darkGrey(isDarkmode: true);

    return Container(
      height: 44.h,
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36.r),
        color: bgColor,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => SearchBloc(
                  currentUser: conversationBloc.currentUser,
                ),
                child: const SearchScreen(),
              ),
            ),
          );
        },
        child: Row(
          children: [
            Spaces.w14,
            Icon(CupertinoIcons.search, color: contentColor, size: 20.r),
            Spaces.w14,
            Text(
              context.languagesExtension.search,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: contentColor),
            ),
          ],
        ),
      ),
    );
  }
}
