import 'package:chat_app/data/response/enum_status.dart';
import 'package:chat_app/data/models/error.dart';

class BaseResponse {
  Status? status;
  int? result = -1;
  int? time;
  Error? error;
  dynamic data;

  BaseResponse({
    this.result,
    this.time,
    this.data,
    this.error,
  });

  BaseResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    time = json['time'];
    if (json['data'] != null) {
      data = json['data'];
    }
    error = (json['error'] != null ? Error.fromJson(json['error']) : null)!;
  }
  BaseResponse.loading() : status = Status.loading;

  BaseResponse.completed({
    required this.result,
    required this.error,
    required this.data,
    required this.time,
  }) : status = Status.completed;

  BaseResponse.error() : status = Status.error;
}
