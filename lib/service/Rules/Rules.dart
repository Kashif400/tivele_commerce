import 'package:e_commerce_foods/service/api_data/api_service.dart';

class RulesService {
  static const String BASE_PATH = "services/app/rule";
  static const String GET_ALL_PATH = "getAllRules";

  static Future<dynamic> getAll() async {
    APIService.baseUrl = BASE_PATH;
    APIService.customPath = GET_ALL_PATH;

    final response = await APIService.getAll();

    return response;
  }
}
