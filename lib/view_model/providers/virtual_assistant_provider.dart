import 'package:chat_app/services/chitchat_service.dart';
import 'package:chat_app/models/ask_chitchat_model.dart';
import 'package:flutter/cupertino.dart';

class VirtualAssistantProvider extends ChangeNotifier {
  List<AskChitChatModel> chatList = [];
  List<AskChitChatModel> get getChatList {
    return chatList;
  }

  addUserMessage({required String msg}) {
    chatList.add(AskChitChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  addErrorMessage({required String msg}) {
    chatList.add(AskChitChatModel(msg: msg, chatIndex: 1));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers({
    required String msg,
    required String chosenModelId,
    required String apiKey,
  }) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ChitChatService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
        apiKey: apiKey
      ));
    } else {
      chatList.addAll(await ChitChatService.sendMessage(
        message: msg,
        modelId: chosenModelId,
        apiKey: apiKey
      ));
    }
    notifyListeners();
  }
}
