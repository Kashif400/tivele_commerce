import 'dart:io';

import 'package:e_commerce_foods/service/api_data/api_endpoint.dart';
import 'package:e_commerce_foods/service/api_data/api_service.dart';
import 'package:e_commerce_foods/service/api_data/request_header.dart';
import 'package:e_commerce_foods/service/api_data/request_response.dart';
import 'package:e_commerce_foods/service/token_auth/client_with_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ProductService {
  static const String BASE_PATH = "services/app/product";
  static const String PIC_PATH = "services/app/ProductPhoto";
  static const String GET_ALL_PATH = "getAll";
  static const String FILE_PATH = "services/app/file";

  static Future<dynamic> get(String? id) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'Get';

    final response = await APIService.getOne(id);

    return response;
  }

  static Future<dynamic> create(message) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'create';
    var response = await APIService.create(message);
    return response;
  }

  static Future<dynamic> uploadPics(message) async {
    APIService.baseUrl = PIC_PATH;
    APIService.customPath = 'AddMutliplePhotos';
    var response = await APIService.uploadPics(message);
    return response;
  }

  static Future<bool> delete(templateId) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'delete';

    final response = await APIService.delete(templateId);

    return response;
  }

  static Future<dynamic> getAll() async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = GET_ALL_PATH;

    final response = await APIService.getAll();

    return response;
  }

  static Future<dynamic> FollowedProductByUser(FollowedProductByUserId) async {
    print(RequestHeader.getHeader());
    final response = await ClientWithInterception.client.get(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
                    .toString() +
                "?FollowedProductByUserId=$FollowedProductByUserId"),
        headers: RequestHeader.getHeader());
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> ProductsByBusinessAccount(BusinessAccountId) async {
    print(RequestHeader.getHeader());
    final response = await ClientWithInterception.client.get(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
                    .toString() +
                "?BusinessAccountId=$BusinessAccountId"),
        headers: RequestHeader.getHeader());
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getProductbyDistance(
      {Longitude, Latitude, DistanceEnum}) async {
    print(RequestHeader.getHeader());
    final response = await ClientWithInterception.client.get(
        Uri.parse(APIEndpoint.endPointUri(
                    baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
                .toString() +
            "?Longitude=$Longitude&Latitude=$Latitude&DistanceEnum=$DistanceEnum"),
        headers: RequestHeader.getHeader());
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getProductLikebyUser(userId) async {
    print(RequestHeader.getHeader());
    final response = await ClientWithInterception.client.get(
        Uri.parse(APIEndpoint.endPointUri(
                    baseUrl: BASE_PATH, customUrl: "GetProductLikeListByUser")
                .toString() +
            "?userId=$userId"),
        headers: RequestHeader.getHeader());
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getProductbyCategory(ProductCategoryId) async {
    print(RequestHeader.getHeader());
    final response = await ClientWithInterception.client.get(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
                    .toString() +
                "?ProductCategoryId=$ProductCategoryId"),
        headers: RequestHeader.getHeader());
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> uploadProduct(File imageFile) async {
    if (await imageFile.exists()) {
      // final mimeTypedData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split("/");
      // print('mimeTypedData: $mimeTypedData');
      String mimeStr = lookupMimeType(imageFile.path)!;
      final mimeTypedData = mimeStr.split('/');
      final uri =
          APIEndpoint.endPointUri(baseUrl: FILE_PATH, customUrl: 'Upload');

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
    }
    throw Exception("The file doesn't exist");
  }

  static Future<dynamic> uploadProduct2(List<String> profileImages) async {
    print("uploadProduct2");
    if (await profileImages.isNotEmpty) {
      // final mimeTypedData = lookupMimeType(profileImages[0], headerBytes: [0xFF, 0xD8]).split("/");
      // print('mimeTypedData: $mimeTypedData');

      var mimeTypedData;
      for (int i = 0; i < profileImages.length; i++) {
        mimeTypedData =
            lookupMimeType(profileImages[i], headerBytes: [0xFF, 0xD8])!
                .split("/");
        print(mimeTypedData);
      }
      final uri =
          APIEndpoint.endPointUri(baseUrl: FILE_PATH, customUrl: 'UploadFiles');
      final imageUploadRequest = http.MultipartRequest("POST", uri);
      // final file = await http.MultipartFile.fromPath("file", imageFile.path,
      //     contentType: MediaType(mimeTypedData[0], mimeTypedData[1]));
      // String images = "";
      // for(int i =0 ; i<profileImages.length; i++){
      //   images = images + profileImages[i]+",";
      //   if(i==profileImages.length-1){
      //     images = images.substring(0, images.length-1);
      //   }
      // }
      // print(images);
      // imageUploadRequest.files.add(http.MultipartFile.fromString('files', images));
      // List<String> ManageTagModel = ['xx', 'yy', 'zz'];
      // var file;
      for (String item in profileImages) {
        mimeTypedData =
            await lookupMimeType(item, headerBytes: [0xFF, 0xD8])!.split("/");
        imageUploadRequest.files.add(await http.MultipartFile.fromPath(
            'files', item,
            contentType: MediaType(mimeTypedData[0], mimeTypedData[1])));
      }
      print(imageUploadRequest.files[0].toString());
      //imageUploadRequest.files.add(file);
      /*imageUploadRequest.headers['Authorization'] =
          RequestHeader.getAuthToken();*/

      var streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      final result = RequestResponse.getFileResult(response);
      return result;
    }
    throw Exception("The file doesn't exist");
  }
}
