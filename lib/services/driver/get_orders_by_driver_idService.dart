import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/models/ordersModel.dart';

import '../../URLS.dart';

class get_orders_by_driver_idService {
  static var client = http.Client();

  static Future fetchGetOrdersByDriverId() async {
    //print(userData);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    Map<String, String> headers = {'Authorization': token};
    var response = await client.get(
        Uri.parse(URLS.BASEURL + URLS.get_orders_by_driver_id),
        headers: headers);

    // var response = await client.get(Uri.parse(URLS.BASEURL + URLS.get_orders),
    //     body: userData);

    try {
      if (response.body.isNotEmpty) {
        var jsonString = response.body;
        print("completed orders!");
        print(response.body);
        return orderServiceModelFromJson(jsonString);
      } else {
        return null;
      }
    } catch (e) {}
  }
}
