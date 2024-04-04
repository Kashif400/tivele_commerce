import 'package:e_commerce_foods/service/api_data/api_service.dart';

class ProductCategoryService {
  static const String BASE_PATH = "services/app/productCategory";
  static const String GET_ALL_PATH = "getAll";

  static Future<dynamic> get(String id) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'Get';

    final response = await APIService.getOne(id);

    return response;
  }

  static Future<bool> create(message) async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = 'create';
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
}
