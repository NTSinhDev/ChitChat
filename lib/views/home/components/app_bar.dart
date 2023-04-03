part of '../home_screen.dart';

AppBar _homeScreenAppBar({
  required BuildContext context,
  required bool theme,
  required Function() openSetting,
}) {
  final currentUser = context.watch<AuthenticationBloc>().userProfile;
  final isDarkmode = context.watch<ThemeProvider>().isDarkMode;
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
                urlImage: currentUser!.urlImage,
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
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminScreen(),
            ),
          );
        },
        icon: const FaIcon(FontAwesomeIcons.userGear),
        color: isDarkmode ? Colors.black : Colors.white,
      ),
      Spaces.w8,
    ],
  );
}
