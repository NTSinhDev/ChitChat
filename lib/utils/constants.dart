const int maxValueInteger = 10000000;
const dateMsg = 'kk:mm dd/MM/yyyy';

class StorageKey {
  /// s là viết tắc SharedPreference
  static const sUID = 'UID';
  static const sLanguage = 'Language';
  static const sTheme = 'Theme';

  /// b là viết tắc của Box
  static const bPROFILE = 'Profile';

  /// p là viết tắc của Path. Used to store images in storage
  static const pPROFILE = 'Profile'; 
  static const pCONVERSATION = 'Conversation';
}

class ProfileField {
  static const String collectionName = "Profiles";
  static const String idUserField = "idUser";
  static const String emailField = "email";
  static const String fullNameField = "fullname";
  // static const String isEmailVerifiedField = "is_email_verified";
  static const String urlImageField = "urlImage";
  static const String userMessagingTokenField = "userMessagingToken";
}

class ConversationsField {
  static const String collectionName = "Conversations";
  static const String chatID = 'id';
  static const String listUser = 'listUser';
  static const String stampTimeLastText = 'stampTimeLastText';
  static const String stampTime = 'stampTime';
  static const String lastText = 'lastText';
  static const String nameChat = 'nameChat';
  static const String isActive = 'isActive';
  static const String typeMessage = 'typeMessage';
}

class ConversationMessagesField {
  static const String collectionName = "ConversationMessages";
  static const String colChildName = "messages";
  static const String id = "id";
  static const String conversationId = "chatID";
  static const String senderId = "senderID";
  static const String stampTime = "stampTime";
  static const String typeMessage = "typeMessage";
  static const String messageStatus = "messageStatus";
  static const String listNameImage = "listNameImage";
  static const String nameRecord = "nameRecord";
  static const String content = "content";
}

class PresenceTree {
  static const String node = "presence";
  static const String statusField = 'status';
  static const String timestampField = 'timestamp';
}
