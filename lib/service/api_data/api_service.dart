import 'dart:convert';

import 'package:e_commerce_foods/service/token_auth/client_with_interceptor.dart';

import './api_endpoint.dart';
import './request_response.dart';
import '../api_data/request_header.dart';

class APIService {
  static String? baseUrl;
  static String profileUrl = "services/app/UserProfile";
  static String? customPath;

  static Future<dynamic> getAll({skipCount = 0, maxResultCount = 1000}) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          "?SkipCount=$skipCount&MaxResultCount=$maxResultCount"),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getAllDriverOrders(Longitude, Latitude) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          "?Status=0&Longitude=$Longitude&Latitude=$Latitude&DistanceEnum=25"),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getAllCompletedOrders(AccountId, Status) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          "?DriverAccountId=$AccountId&Status=$Status"),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getAllById(Id) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          "?UserId=$Id&SkipCount=0&MaxResultCount=1000"),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> FollowByUser(String Id) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          "?UserId=$Id&SkipCount=0&MaxResultCount=1000"),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getFollowsResult(String Id, BusinessAccountId) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          "?UserId=$Id&BusinessAccountId=$BusinessAccountId"),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getOne(idKey) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          '?Id=$idKey'),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }

  static Future<bool> update(jsonObject) async {
    final response = await ClientWithInterception.client.put(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: profileUrl, customUrl: customPath)
                .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(jsonObject));

    return RequestResponse.getBoolResult(response);
  }

  static Future<bool> deleteForMobile(jsonObject) async {
    final response = await ClientWithInterception.client.post(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
                .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(jsonObject));
    return RequestResponse.getBoolResult(response);
  }

  static Future<bool> updateQuestion(jsonObject) async {
    final response = await ClientWithInterception.client.put(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
                .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(jsonObject));

    return RequestResponse.getBoolResult(response);
  }

  static Future<dynamic> create(jsonObject) async {
    final response = await ClientWithInterception.client.post(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
                .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(jsonObject));
    return RequestResponse.getBoolResult(response);
  }

  static Future<dynamic> uploadPics(jsonObject) async {
    final response = await ClientWithInterception.client.post(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
                .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(jsonObject));
    print(json.encode(jsonObject));
    return RequestResponse.getUploadPicResult(response);
  }

  static Future<dynamic> createFollow(jsonObject) async {
    print("error in api_service (create follow) methd");
    print(jsonObject.toString());
    final response = await ClientWithInterception.client.post(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
                .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(jsonObject));
    return RequestResponse.getFollowResult(response);
  }

  static Future<dynamic> createForMobile(jsonObject) async {
    final response = await ClientWithInterception.client.post(
        Uri.parse(
            APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
                .toString()),
        headers: RequestHeader.postHeader(),
        body: json.encode(jsonObject));

    return RequestResponse.getResult(response);
  }

  static Future<dynamic> delete(idKey) async {
    final response = await ClientWithInterception.client.delete(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          '?id=$idKey'),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getBoolResult(response);
  }

  static Future<dynamic> deleteQuestion(idKey) async {
    final response = await ClientWithInterception.client.delete(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          '?id=$idKey'),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getBoolResult(response);
  }
}
