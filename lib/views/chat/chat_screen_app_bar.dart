part of "chat_screen.dart";

AppBar buildAppBar(BuildContext context, UserProfile friendInfo) {
  final theme = context.watch<ThemeProvider>().isDarkMode;
  return AppBar(
    toolbarHeight: 68.h,
    backgroundColor: AppColors(themeMode: theme).baseTheme,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () => Navigator.pop(context),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StateAvatar(
          urlImage: friendInfo.urlImage,
          userId: friendInfo.profile?.id ?? '',
          color: AppColors(themeMode: theme).baseTheme,
          radius: 44.r,
        ),
        Spaces.w20,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SplitUtilities.formatName(
                name: friendInfo.profile!.fullName,
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white, fontSize: 15.r),
            ),
            PresenceStreamWidget(
              userId: friendInfo.profile!.id!,
              child: (presence) {
                if (presence == null) return Container();
                return Text(
                  presence.status
                      ? context.languagesExtension.onl
                      : "${TimeUtilities.differenceTime(context: context, earlier: presence.timestamp)} ${context.languagesExtension.ago}",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 10.r, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ],
    ),
    actions: [
      IconButton(
        onPressed: () {
          FlashMessageWidget(
            context: context,
            message: 'Chưa làm gì hết!',
            type: FlashMessageType.info,
          );
        },
        icon: const Icon(
          CupertinoIcons.ellipsis_vertical,
          color: Colors.white,
        ),
      ),
    ],
  );
}
