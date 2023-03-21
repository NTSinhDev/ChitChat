import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/ask_chitchat_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseURL = "https://api.openai.com/v1";
  static const apiKey = "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";

  // Send Message using ChatGPT API
  static Future<List<AskChitChatModel>> sendMessageGPT({
    required String message,
    required String modelId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseURL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<AskChitChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => AskChitChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"].replaceAll("\n", ""),
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Send Message fct
  static Future<List<AskChitChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var response = await http.post(
        Uri.parse("$baseURL/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );

      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<AskChitChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => AskChitChatModel(
            msg: jsonResponse["choices"][index]["text"].replaceAll("\n", ""),
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
