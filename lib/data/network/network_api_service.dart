import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/core/exception/app_exception.dart';
import 'package:chat_app/data/network/base_api_service.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiServices {
  @override
  Future getPostApiResponse(String url, dynamic data, dynamic headers) async {
    dynamic responseJson;

    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers: headers,
          )
          .timeout(
            const Duration(seconds: 100),
          );

      responseJson = returnResponse(response);
    } on SocketException {
      log("Can't post request to server!");
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        final responseJson = jsonDecode(response.body);
        return responseJson;

      case 404:
      case 500:
        final responseJson = jsonDecode(response.body);
        return responseJson;

      default:
        final responseJson = jsonDecode(response.body);
        return responseJson;
    }
  }

  @override
  Future postMultipartApiWithMutiFiles(
    String url,
    String field,
    List<String> paths,
  ) async {
    dynamic responseJson;

    try {
      final request = http.MultipartRequest("POST", Uri.parse(url));
      for (var p in paths) {
        request.files.add(
          await http.MultipartFile.fromPath(
            field,
            p,
          ),
        );
      }

      request.headers.addAll({
        "Content-type": "multipart/form-data",
      });

      http.StreamedResponse streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      responseJson = returnResponse(response);
    } on SocketException {
      log("Can't post request to server!");
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postMultipartFile(
    String url,
    String field,
    String path,
    String? userID,
  ) async {
    dynamic responseJson;

    try {
      final request = http.MultipartRequest("POST", Uri.parse(url));

      request.files.add(await http.MultipartFile.fromPath(field, path));
      if (userID != null) {
        request.fields.addAll({'userID': userID});
      }

      request.headers.addAll({
        "Content-type": "multipart/form-data",
      });

      http.StreamedResponse streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      responseJson = returnResponse(response);
    } on SocketException {
      log("Can't post request to server!");
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
}
