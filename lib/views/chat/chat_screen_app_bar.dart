part of "chat_screen.dart";

AppBar buildAppBar(BuildContext context, UserProfile friendInfo) {
  final theme = context.watch<ThemeProvider>().isDarkMode;
  return AppBar(
    toolbarHeight: 68.h,
    backgroundColor: ResColors.purpleMessage(theme: theme),
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
          color: ResColors.purpleMessage(theme: theme),
          radius: 44.r,
        ),
        Spaces.w20,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SplitHelper.formatName(
                name: friendInfo.profile!.fullName,
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white, fontSize: 15.r),
            ),
            _ActiveStatus(userId: friendInfo.profile?.id),
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

class _ActiveStatus extends StatelessWidget {
  final String? userId;
  const _ActiveStatus({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: PresenceRemoteDatasourceImpl().getPresence(userID: userId ?? ''),
      builder: (context, snapshotDBEvnet) {
        final bool condition1 = snapshotDBEvnet.hasData;
        final bool condition2 = snapshotDBEvnet.data != null;
        final bool condition3 = snapshotDBEvnet.data?.snapshot.value != null;
        UserPresence? presence;
        if (condition1 && condition2 && condition3) {
          final data = snapshotDBEvnet.data!.snapshot;
          final mapStringDynamic = Map<String, dynamic>.from(data.value as Map);
          presence = UserPresence.fromMap(mapStringDynamic, data.key!);
        }
        if (presence != null) {
          return buildStatus(context, presence: presence);
        }
        return Container();
      },
    );
  }

  Widget buildStatus(BuildContext context, {required UserPresence presence}) {
    return Text(
      presence.status
          ? context.languagesExtension.onl
          : "${TimeFormat.differenceTime(context: context, earlier: presence.timestamp)} ${context.languagesExtension.ago}",
      style: Theme.of(context)
          .textTheme
          .labelLarge!
          .copyWith(fontSize: 10.r, color: Colors.white),
    );
  }
}
