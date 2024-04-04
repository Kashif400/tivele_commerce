import 'dart:convert';
import 'dart:io';

import 'package:e_commerce_foods/service/token_auth/client_with_interceptor.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../api_data/api_endpoint.dart';
import '../api_data/api_service.dart';
import '../api_data/request_header.dart';
import '../api_data/request_response.dart';

class UserProfileService {
  static const String BASE_PATH = "services/app/UserProfile";
  static const String File_Path = "services/app/File";
  static const String Profile_Path = "services/app/UserProfile";

  static Future<dynamic> getUser(int id) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'Get';

    final userJson = await APIService.getOne(id);
    return userJson;
  }

  static Future<dynamic> getProfile() async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(
              baseUrl: BASE_PATH, customUrl: "GetUserProfile")
          .toString()),
      headers: RequestHeader.getHeader(),
    );
    final profil = RequestResponse.getResult(response);
    SessionService.addUser(profil['id']);
    return profil;
  }

  static Future<dynamic> getProfileById(int id) async {
    final result = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(
                  baseUrl: BASE_PATH, customUrl: "GetUserProfileById")
              .toString() +
          "?id=" +
          id.toString()),
      headers: RequestHeader.getHeader(),
    );
    final profile = RequestResponse.getResult(result);
    return profile;
  }

  static Future<bool> updateProfile(account) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'UpdateUserProfile';

    final isUpdated = await APIService.update(account);

    return isUpdated;
  }

  static Future<dynamic> saveProfilePicture(File imageFile) async {
    // if (await imageFile.exists()) {
    //   final mimeTypedData =
    //   lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split("/");
    //   print('mimeTypedData: $mimeTypedData');
    //
    //   final uri = APIEndpoint.endPointUri(
    //       baseUrl: File_Path, customUrl: 'Upload');
    //
    //   final imageUploadRequest = http.MultipartRequest("POST", uri);
    //
    //   final file = await http.MultipartFile.fromPath(
    //       "ProfileImage", imageFile.path,
    //       contentType: MediaType(mimeTypedData[0], mimeTypedData[1]));
    //
    //   imageUploadRequest.files.add(file);
    //   imageUploadRequest.headers['Authorization'] =
    //       RequestHeader.getAuthToken();
    //
    //   var streamedResponse = await imageUploadRequest.send();
    //   final response = await http.Response.fromStream(streamedResponse);
    //   return RequestResponse.getFileResult(response);
    // }
    if (await imageFile.exists()) {
      final mimeTypedData =
          lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])!.split("/");
      print('mimeTypedData: $mimeTypedData');

      final uri =
          APIEndpoint.endPointUri(baseUrl: File_Path, customUrl: 'Upload');

      final imageUploadRequest = http.MultipartRequest("POST", uri);

      final file = await http.MultipartFile.fromPath("file", imageFile.path,
          contentType: MediaType(mimeTypedData[0], mimeTypedData[1]));

      imageUploadRequest.files.add(file);
      /*imageUploadRequest.headers['Authorization'] =
          RequestHeader.getAuthToken();*/

      var streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      final result = RequestResponse.getFileResult(response);
      return result;

      // return RequestResponse.getFileResult(response);
    }
  }

  static Future<String?> getProfilePicture() async {
    final response = await ClientWithInterception.client.get(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH, customUrl: 'GetProfilePicture')
            .toString()),
        headers: RequestHeader.getHeader());

    final result = RequestResponse.getResult(response);

    return result['profileImage'];
  }

  static Future<dynamic> getAccountType(UserId) async {
    final response = await ClientWithInterception.client.get(
        Uri.parse(APIEndpoint.endPointUri(
                    baseUrl: BASE_PATH, customUrl: 'GetAccountType')
                .toString() +
            "?Id=$UserId"),
        headers: RequestHeader.getHeader());

    final result = RequestResponse.getResult(response);

    return result;
  }

  static Future<bool> deleteProfilePicture() async {
    final response = await ClientWithInterception.client.delete(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH, customUrl: 'DeleteProfilePicture')
            .toString()),
        headers: RequestHeader.getHeader());

    return RequestResponse.getBoolResult(response);
  }

  static Future<dynamic> changePassword(account) async {
    final response = await ClientWithInterception.client.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH, customUrl: 'ChangeUserPassword')
            .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(account));
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> accountLogin(account) async {
    final response = await ClientWithInterception.client.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH, customUrl: 'AccountLogin')
            .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(account));
    return RequestResponse.getResult(response);
  }
}
