part of '../home_screen.dart';

AppBar _homeScreenAppBar({
  required BuildContext context,
  required URLImage urlImage,
  required bool theme,
  required Function() openSetting,
}) {
  return AppBar(
    toolbarHeight: 68.h,
    backgroundColor: ResColors.purpleMessage(theme: theme),
    title: Row(
      children: [
        GestureDetector(
          onTap: () => openSetting(),
          child: Container(
            margin: EdgeInsets.only(right: 16.w),
            child: Center(
              child: StateAvatar(
                urlImage: urlImage,
                userId: '',
                radius: 44.r,
              ),
            ),
          ),
        ),
        Text(
          context.languagesExtension.chats,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Colors.white),
        ),
      ],
    ),
  );
}
