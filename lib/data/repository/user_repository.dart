import 'package:chat_app/data/environment.dart';
import 'package:chat_app/data/interfaces/i_service_api.dart';
import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/data/response/base_response.dart';
import 'package:chat_app/data/models/error.dart';
import '../network/base_api_service.dart';
import '../network/network_api_service.dart';

class UserRepository extends IServiceAPI{
  String urlEndPointChangeDarkMode = "user/changeDarkMode";
  String urlEndPointUploadImg = "user/upload";

  final BaseApiServices apiServices = NetworkApiService();
  late Environment environment;

  UserRepository({required this.environment}) {
    urlEndPointChangeDarkMode = environment.baseURL + urlEndPointChangeDarkMode;
    urlEndPointUploadImg = environment.baseURL + urlEndPointUploadImg;
  }

  @override
  List convertDynamicToList({required BaseResponse value}) {
    throw UnimplementedError();
  }

  @override
  User convertDynamicToObject(value) {
    return User.fromJson(value);
  }

  @override
  Error convertDynamicToError(value) {
    return Error.fromJson(value);
  }

  Future<BaseResponse?> changeDarkMode({required data, required header}) async {
    try {
      final response = await apiServices.getPostApiResponse(
        urlEndPointChangeDarkMode,
        data,
        header,
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (_) {
      return null;
    }
  }

  /// This function to send images, return list paths.
  Future<dynamic> uploadAvatar({required String path, required String userID}) async {
    try {
      final response = await apiServices.postMultipartFile(
        urlEndPointUploadImg,
        "avatars",
        path,
        userID,
      );
      return response['path'];
    } on Exception catch (_) {
      return null;
    }
  }
}
