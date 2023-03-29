import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

abstract class ApiServices {
  Future<http.Response> post({
    required String url,
    required Map<String, dynamic> dataBody,
    required Map<String, String> headers,
  });
}

class ApiServicesImpl extends ApiServices {
  @override
  Future<http.Response> post({
    required String url,
    required Map<String, dynamic> dataBody,
    required Map<String, String> headers,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(dataBody),
            headers: headers,
          )
          .timeout(
            const Duration(seconds: 10),
          );

      return response;
    } catch (error) {
      log('🚀ApiServicesImpl - post⚡ lỗi khi post api\n ${error.toString()}');
      throw const HttpException('No Internet Connection');
    }
  }
}
