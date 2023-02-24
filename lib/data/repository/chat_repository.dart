import 'package:chat_app/data/environment.dart';
import 'package:chat_app/data/interfaces/i_service_api.dart';
import 'package:chat_app/data/models/auth_user.dart';
import 'package:chat_app/data/response/base_response.dart';
import 'package:chat_app/data/models/error.dart';
import '../network/base_api_service.dart';
import '../network/network_api_service.dart';

class ChatRepository extends IServiceAPI {
  String endPointFindAUser = "chat/findAUser";
  String endPointGetFriendRequests = "chat/getFriendRequests";
  String endPointRemoveRequest = "chat/removeRequest";
  String endPointUploadMultiFiles = "chat/multiUpload";
  String endPointUploadFile = "chat/upload";

  final BaseApiServices apiServices = NetworkApiService();
  late Environment environment;

  ChatRepository({required this.environment}) {
    endPointFindAUser = environment.baseURL + endPointFindAUser;
    endPointGetFriendRequests = environment.baseURL + endPointGetFriendRequests;
    endPointRemoveRequest = environment.baseURL + endPointRemoveRequest;
    endPointUploadMultiFiles = environment.baseURL + endPointUploadMultiFiles;
    endPointUploadFile = environment.baseURL + endPointUploadFile;
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

  /// Find a user to add new friend request. This function return infomations of user
  Future<BaseResponse?> findUser({required data}) async {
    try {
      final response = await apiServices.getPostApiResponse(
        endPointFindAUser,
        data,
        {'Content-Type': 'application/json'},
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (_) {
      return null;
    }
  }

  /// This function to get list friend request
  Future<BaseResponse?> getFriendRequests({required data}) async {
    try {
      final response = await apiServices.getPostApiResponse(
        endPointGetFriendRequests,
        data,
        {'Content-Type': 'application/json'},
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (_) {
      return null;
    }
  }

  /// This function to remove a friend request
  Future<BaseResponse?> removeRequest({required data}) async {
    try {
      final response = await apiServices.getPostApiResponse(
        endPointRemoveRequest,
        data,
        {'Content-Type': 'application/json'},
      );
      return BaseResponse.fromJson(response);
    } on Exception catch (_) {
      return null;
    }
  }

  /// This function to send images, return list paths.
  Future<dynamic> sendImages({required List<String> paths}) async {
    try {
      final response = await apiServices.postMultipartApiWithMutiFiles(
        endPointUploadMultiFiles,
        "chats",
        paths,
      );
      return response['paths'];
    } on Exception catch (_) {
      return null;
    }
  }

  /// This function to send images, return list paths.
  Future<dynamic> sendAudio({required String path}) async {
    try {
      final response = await apiServices.postMultipartFile(
        endPointUploadFile,
        "chats",
        path,
        null
      );
      return response['path'];
    } on Exception catch (_) {
      return null;
    }
  }  
}
