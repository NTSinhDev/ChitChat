import 'package:chat_app/data/response/base_response.dart';

abstract class IServiceAPI {
  List<dynamic> convertDynamicToList({required BaseResponse value});

  dynamic convertDynamicToObject(dynamic value);
  dynamic convertDynamicToError(dynamic value);
}
