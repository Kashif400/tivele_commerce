import 'package:e_commerce_foods/service/api_data/api_endpoint.dart';
import 'package:e_commerce_foods/service/api_data/api_service.dart';
import 'package:e_commerce_foods/service/api_data/request_header.dart';
import 'package:e_commerce_foods/service/api_data/request_response.dart';
import 'package:e_commerce_foods/service/token_auth/client_with_interceptor.dart';

class ReviewsService {
  static const String BASE_PATH = "services/app/Review";
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

  static Future<dynamic> getAllByProduct(productId) async {
    final response = await ClientWithInterception.client.get(
      Uri.parse(
          APIEndpoint.endPointUri(baseUrl: BASE_PATH, customUrl: GET_ALL_PATH)
                  .toString() +
              '?productId=$productId'),
      headers: RequestHeader.getHeader(),
    );

    return RequestResponse.getResult(response);
  }
}
