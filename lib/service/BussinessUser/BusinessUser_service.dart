import 'package:e_commerce_foods/service/api_data/api_endpoint.dart';
import 'package:e_commerce_foods/service/api_data/api_service.dart';
import 'package:e_commerce_foods/service/api_data/request_header.dart';
import 'package:e_commerce_foods/service/api_data/request_response.dart';
import 'package:e_commerce_foods/service/token_auth/client_with_interceptor.dart';

class BusinessUserService {
  static const String BASE_PATH = "services/app/BusinessAccount";
  static const String GET_ALL_PATH = "getAll";

  static Future<dynamic> get(String id) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'Get';
    final response = await APIService.getOne(id);

    return response;
  }

  static Future<bool> create(message) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'Create';
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

  static Future<dynamic> FollowByUser(String Id) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = GET_ALL_PATH;

    final response = await APIService.FollowByUser(Id);

    return response;
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
