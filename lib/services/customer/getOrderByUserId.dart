import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/models/customer/getOrderByUserId.dart';

import '../../URLS.dart';

class getOrderByUserIdServices {
  static var client = http.Client();

  static Future fetchOrderByUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    Map<String, String> headers = {'Authorization': token};
    var response = await client.get(
        Uri.parse(URLS.BASEURL + URLS.get_orders_by_user_id),
        headers: headers);
    try {
      if (response.body.isNotEmpty) {
        var jsonString = response.body;
        print(response.body);
        return getOrdersByUserIdServiceFromJson(jsonString);
      } else {
        return null;
      }
    } catch (e) {}
  }
}
