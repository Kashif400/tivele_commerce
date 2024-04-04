import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/models/business/getCategoriesModel.dart';

class GetCategoriesService {
  static var client = http.Client();

  static Future fetchCategoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    print(token);
    Map<String, String> headers = {'Authorization': token};
    var response = await client.get(
        Uri.parse(URLS.BASEURL + URLS.get_product_categories),
        headers: headers);

    try {
      if (response.body.isNotEmpty) {
        var jsonString = response.body;
        print(response.body);
        return getCategoriesMFromJson(jsonString);
      } else {
        return null;
      }
    } catch (e) {}
  }
}
