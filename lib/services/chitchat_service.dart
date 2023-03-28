// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:chat_app/models/ask_chitchat_model.dart';
import 'package:chat_app/utils/injector.dart';

const _headers = {
  'Authorization': 'Bearer $chatGPTAPIKey',
  "Content-Type": "application/json",
};

class ChitChatService {
  // Send Message using ChatGPT API
  static Future<List<AskChitChatModel>> sendMessageGPT({
    required String message,
    required String modelId,
  }) async {
    try {
      final url = Uri.parse("$openAIBaseURL/chat/completions");
      final data = {
        "model": modelId,
        "messages": [
          {
            "role": "user",
            "content": message,
          }
        ]
      };
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(data),
      );
      return _getListMessage(reponse: response.bodyBytes);
    } catch (error) {
      log("sendMessageGPT Error:\n $error");
      rethrow;
    }
  }

  // Send Message fct
  static Future<List<AskChitChatModel>> sendMessage({
    required String message,
    required String modelId,
  }) async {
    try {
      final url = Uri.parse("$openAIBaseURL/completions");
      final data = {
        "model": modelId,
        "prompt": message,
        "max_tokens": 300,
      };
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(data),
      );
      return _getListMessage(reponse: response.bodyBytes);
    } catch (error) {
      log("sendMessage Error:\n $error");
      rethrow;
    }
  }
}

List<AskChitChatModel> _getListMessage({required List<int> reponse}) {
  _BaseResponse baseResponse = _BaseResponse.fromJson(reponse);
  if (baseResponse.error != null) {
    throw HttpException(baseResponse.error!.message);
  }
  List<AskChitChatModel> chatList =
      baseResponse.choices.map((choice) => choice.message).toList();
  return chatList;
}

class _BaseResponse {
  _BaseResponseError? error;
  final List<_BaseResponseChoice> choices;
  _BaseResponse({
    required this.choices,
    this.error,
  });

  factory _BaseResponse.fromMap(Map<String, dynamic> map) {
    return _BaseResponse(
      choices: map['choices'] != null
          ? [_BaseResponseChoice.fromMap(map['choices'][0])]
          : [],
      error: map['error'] != null
          ? _BaseResponseError.fromMap(map['error'])
          : null,
    );
  }

  factory _BaseResponse.fromJson(List<int> source) => _BaseResponse.fromMap(
      json.decode(utf8.decode(source)) as Map<String, dynamic>);
}

class _BaseResponseChoice {
  final AskChitChatModel message;
  _BaseResponseChoice({
    required this.message,
  });

  factory _BaseResponseChoice.fromMap(Map<String, dynamic> map) {
    return _BaseResponseChoice(
      message: AskChitChatModel(
        msg: map["message"]["content"].replaceAll("\n", ""),
        chatIndex: 1,
      ),
    );
  }
}

class _BaseResponseError {
  final String code;
  final String message;
  _BaseResponseError({
    required this.code,
    required this.message,
  });

  factory _BaseResponseError.fromMap(Map<String, dynamic> map) {
    return _BaseResponseError(
      code: map['code'] as String,
      message: map['code'] == "invalid_api_key"
          ? "Lỗi API key"
          : map['message'] as String,
    );
  }
}
