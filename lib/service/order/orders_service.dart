import 'dart:io';

import 'package:e_commerce_foods/service/api_data/api_endpoint.dart';
import 'package:e_commerce_foods/service/api_data/api_service.dart';
import 'package:e_commerce_foods/service/api_data/request_header.dart';
import 'package:e_commerce_foods/service/api_data/request_response.dart';
import 'package:e_commerce_foods/service/product/product_service.dart';
import 'package:e_commerce_foods/service/token_auth/client_with_interceptor.dart';

class OrdersService {
  static const String BASE_PATH = "services/app/order";
  static const String GET_ALL_PATH = "getAll";
  static const String GET_User_ID = "getOrdersListByUserId";

  static Future<dynamic> get(String id) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'Get';

    final response = await APIService.getOne(id);

    return response;
  }

  static Future<dynamic> create(message) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'createForMobile';
    final response = await APIService.createForMobile(message);

    return response;
  }

  static Future<dynamic> AcceptOrder(message) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'AcceptOrder';
    final response = await APIService.create(message);
    return response;
  }

  static Future<dynamic> UpdateOrderStatus(message) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'UpdateOrderStatus';
    final response = await APIService.create(message);
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

  static Future<dynamic> getAllDriversOrders({Longitude, Latitude}) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = GET_ALL_PATH;

    final response = await APIService.getAllDriverOrders(Longitude, Latitude);

    return response;
  }

  static Future<dynamic> getAllCompletedOrders(AccountId, status) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = GET_ALL_PATH;

    final response = await APIService.getAllCompletedOrders(AccountId, status);

    return response;
  }

  static Future<dynamic> getOrderListByUserId(userId) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(
          APIEndpoint.endPointUri(baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
                  .toString() +
              '?userId=$userId&MaxResultCount=1000'),
      headers: RequestHeader.getHeader(),
    );

    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getMoreOrderListByUserId(userId, skipCount) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(
          APIEndpoint.endPointUri(baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
                  .toString() +
              '?userId=$userId&SkipCount=$skipCount&MaxResultCount=10'),
      headers: RequestHeader.getHeader(),
    );

    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getAllByOffer(
      {offerId, skipCount = 0, maxResultCount = 5}) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(
                  baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
              .toString() +
          "?offerId=$offerId&SkipCount=$skipCount&MaxResultCount=$maxResultCount"),
      headers: RequestHeader.getHeader(),
    );

    return RequestResponse.getResult(response);
  }

  static Future<String> productUpload(File file) async {
    try {
      var profileImageUrl = await ProductService.uploadProduct(file);
      // GlobalProperty.imageUrl = profileImageUrl;
      //await SessionService.setProfileImageUrl(profileImageUrl);
      return profileImageUrl.toString();
    } catch (err) {
      return err.toString();
    }
  }

  static Future<dynamic> getAllByOfferLocal(
      {offerId, skipCount = 0, maxResultCount = 5}) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(
          APIEndpoint.endPointUri(baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
                  .toString() +
              "?offerId=$offerId&SkipCount=$skipCount"),
      headers: RequestHeader.getHeader(),
    );

    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getConversation(
      {userId, skipCount = 0, maxResultCount = 5}) async {
    print(RequestHeader.getHeader());
    final response = await ClientWithInterception.client.get(
        Uri.parse(APIEndpoint.endPointUri(
                    baseUrl: BASE_PATH, customUrl: "GetConversation")
                .toString() +
            "?id=$userId"),
        headers: RequestHeader.getHeader());

    return RequestResponse.getResult(response);
  }
}
