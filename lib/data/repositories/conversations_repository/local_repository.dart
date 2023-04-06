part of 'conversations_repository.dart';

abstract class LocalConversationsRepository {
  Future<void> createConversation({
    required Conversation conversation,
    required UserProfile friendProfile,
  });
  Future<List<ConversationData>> getConversationsData(String currentUserId);
  Conversation? getConversation({required String key});
  Future<void> openBoxs();
}

class _LocalRepositoryImpl implements LocalConversationsRepository {
  final _conversationsLocalDS = ConversationsLocalDataSourceImpl();
  final _profileLocalDS = ProfileLocalDataSourceImpl();
  final _storageLocalDS = StorageLocalDataSourceImpl();
  @override
  Future<void> createConversation({
    required Conversation conversation,
    required UserProfile friendProfile,
  }) async {
    await _conversationsLocalDS.createConversation(conversation: conversation);

    if (friendProfile.profile != null && friendProfile.urlImage.url != null) {
      await _profileLocalDS.saveProfileToBox(friendProfile.profile!);
      await _storageLocalDS.uploadFile(
        fileName: friendProfile.profile!.id!,
        remotePath: friendProfile.urlImage.url!,
      );
    }
  }

  @override
  Conversation? getConversation({required String key}) =>
      _conversationsLocalDS.getConversation(key: key);

  @override
  Future<List<ConversationData>> getConversationsData(
    String currentUserId,
  ) async {
    List<ConversationData> datas = [];
    final conversations = _conversationsLocalDS.getConversations().toList();
    conversations.sort((a, b) => b.stampTimeLastText.compareTo(a.stampTime));
    for (var i = 0; i < conversations.length; i++) {
      final friendId = conversations[i].listUser.length == 1
          ? conversations[i].listUser[0]
          : conversations[i]
              .listUser
              .firstWhere((element) => element != currentUserId);
      final Profile? profile = _profileLocalDS.getProfile(friendId);
      final urlImage = URLImage(
        url: await _storageLocalDS.getFile(fileName: friendId),
        type: TypeImage.local,
      );
      final UserProfile friend = UserProfile(
        urlImage: urlImage,
        profile: profile,
      );

      datas.add(
        ConversationData(
          conversation: conversations[i],
          friend: friend,
        ),
      );
    }
    return datas;
  }

  @override
  Future<void> openBoxs() async {
    await _conversationsLocalDS.init();
    await _profileLocalDS.openBox();
  }
}
