import 'package:chat_app/data/environment.dart';
import 'package:chat_app/data/interfaces/i_service_api.dart';
import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/data/response/base_response.dart';
import 'package:chat_app/data/models/error.dart';
import '../network/base_api_service.dart';
import '../network/network_api_service.dart';

class AuthRepository extends IServiceAPI {
  String urlEndPointLoginToken = "auth/loginwithaccesstoken";
  String urlEndPointRegister = "auth/register";
  String urlEndPointLogin = "auth/login";
  String urlEndPointLogout = "auth/logout";

  final BaseApiServices apiServices = NetworkApiService();
  late Environment environment;

  AuthRepository({required this.environment}) {
    urlEndPointRegister = environment.baseURL + urlEndPointRegister;
    urlEndPointLogin = environment.baseURL + urlEndPointLogin;
    urlEndPointLoginToken = environment.baseURL + urlEndPointLoginToken;
    urlEndPointLogout = environment.baseURL + urlEndPointLogout;
  }

  @override
  List convertDynamicToList({required BaseResponse value}) {
    throw UnimplementedError();
  }

  @override
  AuthUser convertDynamicToObject(value) {
    return AuthUser.fromJson(value);
  }

  @override
  Error convertDynamicToError(dynamic value) {
    return Error.fromJson(value);
  }

  Future<BaseResponse?> getDataLogin({required data, required header}) async {
    try {
      final response = await apiServices.getPostApiResponse(
        urlEndPointLogin,
        data,
        header,
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (_) {
      return null;
    }
  }

  Future<BaseResponse?> getDataLoginWithAccessToken({
    required data,
    required header,
  }) async {
    try {
      final response = await apiServices.getPostApiResponse(
        urlEndPointLoginToken,
        data,
        header,
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (_) {
      return null;
    }
  }

  Future<BaseResponse?> getDataRegister({
    required data,
    required header,
  }) async {
    try {
      final response = await apiServices.getPostApiResponse(
        urlEndPointRegister,
        data,
        header,
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (_) {
      return null;
    }
  }

  Future<BaseResponse?> getDataLogout({required data, required header}) async {
    try {
      final response = await apiServices.getPostApiResponse(
        urlEndPointLogout,
        data,
        header,
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (_) {
      return null;
    }
  }
}
