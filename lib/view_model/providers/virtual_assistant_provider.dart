import 'package:chat_app/services/api_service.dart';
import 'package:chat_app/models/ask_chitchat_model.dart';
import 'package:flutter/cupertino.dart';

class VirtualAssistantProvider with ChangeNotifier {
  List<AskChitChatModel> chatList = [];
  List<AskChitChatModel> get getChatList {
    return chatList;
  }

  addUserMessage({required String msg}) {
    chatList.add(AskChitChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  addErrorMessage({required String msg}){
    chatList.add(AskChitChatModel(msg: msg, chatIndex: 1));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers({
    required String msg,
    required String chosenModelId,
  }) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
