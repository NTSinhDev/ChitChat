class AskChitChatModel {
  final String msg;
  final int chatIndex;

  AskChitChatModel({required this.msg, required this.chatIndex});

  factory AskChitChatModel.fromJson(Map<String, dynamic> json) =>
      AskChitChatModel(
        msg: json["msg"],
        chatIndex: json["chatIndex"],
      );
}
