const int maxValueInteger = 10000000;
const dateMsg = 'kk:mm dd/MM/yyyy';

class StorageKey {
  /// s là viết tắc SharedPreference
  static const sUID = 'UID';
  static const sLanguage = 'Language';
  static const sTheme = 'Theme';

  /// b là viết tắc của Box
  static const bPROFILE = 'Profile';

  /// p là viết tắc của Path
  static const pPROFILE = 'Profile';
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
  static const String collectionChildName = "messages";
  static const String idField = "id"; 
  static const String chatIdField = "chatID"; 
  static const String senderIdField = "senderID"; 
  static const String stampTimeField = "stampTime"; 
  static const String typeMessageField = "typeMessage"; 
  static const String messageStatusField = "messageStatus"; 
  static const String listNameImageField = "listNameImage"; 
  static const String nameRecordField = "nameRecord"; 
  static const String contentField = "content"; 
}