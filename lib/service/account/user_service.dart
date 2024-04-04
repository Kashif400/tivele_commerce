import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:e_commerce_foods/service/token_auth/client_with_interceptor.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import '../api_data/api_endpoint.dart';
import '../api_data/api_service.dart';
import '../api_data/request_header.dart';
import '../api_data/request_response.dart';

class UserService {
  static const String BASE_PATH = "services/app/UserProfile";
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

  static Future<bool> updateProfile(userProfileId) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'UpdateUserProfile';

    final isUpdated = await APIService.update(userProfileId);

    return isUpdated;
  }

  static Future<dynamic> saveProfilePicture(File imageFile) async {
    if (await imageFile.exists()) {
      final mimeTypedData =
          lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])!.split("/");
      print('mimeTypedData: $mimeTypedData');

      final uri = APIEndpoint.endPointUri(
          baseUrl: BASE_PATH, customUrl: 'SaveProfilePicture');

      final imageUploadRequest = http.MultipartRequest("POST", uri);

      final file = await http.MultipartFile.fromPath(
          "ProfileImage", imageFile.path,
          contentType: MediaType(mimeTypedData[0], mimeTypedData[1]));

      imageUploadRequest.files.add(file);
      imageUploadRequest.headers['Authorization'] =
          RequestHeader.getAuthToken();

      var streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      return RequestResponse.getFileResult(response);
    }
    throw Exception("The file doesn't exist");
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

  static Future<bool> deleteProfilePicture() async {
    final response = await ClientWithInterception.client.delete(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH, customUrl: 'DeleteProfilePicture')
            .toString()),
        headers: RequestHeader.getHeader());

    return RequestResponse.getBoolResult(response);
  }

  static Future<bool> saveProductRequest(productRequest) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'SaveProductRequest';

    final isSaved = await APIService.create(productRequest);

    return isSaved;
  }

  static Future<dynamic> getAllSavedProductRequest(
      {skipCount = 0, maxResultCount = 5}) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'GetAllSavedProductRequests';

    final jsonRequests = await APIService.getAll(
        skipCount: skipCount, maxResultCount: maxResultCount);

    return jsonRequests;
  }

  static Future<bool> hiddenProductRequest(productRequest) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'HideProductRequest';

    final isHidden = await APIService.create(productRequest);

    return isHidden;
  }

  static Future<dynamic> getAllHiddenProductRequest(
      {skipCount = 0, maxResultCount = 5}) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'GetAllHiddenProductRequests';

    final jsonRequests = await APIService.getAll(
        skipCount: skipCount, maxResultCount: maxResultCount);

    return jsonRequests;
  }
}
