import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../URLS.dart';

class GetFavoriteProductsService {
  static var client = http.Client();

  static Future fetchFavouriteProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    Map<String, String> headers = {'Authorization': token};
    var response = await client.get(
        Uri.parse(URLS.BASEURL + URLS.get_favorite_products),
        headers: headers);
    try {
      if (response.body.isNotEmpty) {
        var jsonString = response.body;
        print(response.body);
        return getExploreDataMFromJson(jsonString);
      } else {
        return null;
      }
    } catch (e) {}
  }
}
