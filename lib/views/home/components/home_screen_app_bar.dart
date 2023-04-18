part of '../home_screen.dart';

SliverAppBar _homeScreenAppBar({
  required BuildContext context,
  required URLImage urlImage,
  required Function() openSetting,
}) {
  final theme = context.watch<ThemeProvider>().isDarkMode;
  return SliverAppBar(
    pinned: true,
    floating: true,
    toolbarHeight: 64.h,
    backgroundColor: AppColors.appColor(isDarkmode: !theme),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: openSetting,
          child: StateAvatar(
            urlImage: urlImage,
            radius: 40.r,
            isBorder: true,
          ),
        ),
        Spaces.w16,
        Text(
          context.languagesExtension.chats,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: theme ? Colors.white : Colors.black),
        ),
      ],
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(64.h),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: const SearchBar(),
      ),
    ),
  );
}
