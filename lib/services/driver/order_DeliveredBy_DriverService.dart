import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';

import '../../URLS.dart';

class orderDeliveredByDriver {
  static var client = http.Client();

  // static Future fetchOrderDeliveredByDriver(
  //     Map<String, Object> userData) async {
  //   print(userData);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString("token");
  //   Map<String, String> headers = {'Authorization': token};
  //   var response = await client.post(
  //       Uri.parse(URLS.BASEURL + URLS.order_delivered_by_driver),
  //       body: userData,
  //       headers: headers);
  //
  //   try {
  //     if (response.body.isNotEmpty) {
  //       var jsonString = response.body;
  //       print(response.body);
  //       return checkApiResponseMFromJson(jsonString);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {}
  // }
  static Future fetchOrderDeliveredByDriver(
      Map<String, String?> userData) async {
    print(userData);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    Map<String, String> headers = {'Authorization': token};
    var response = await client.post(
        Uri.parse(URLS.BASEURL + URLS.order_delivered_by_driver),
        body: userData,
        headers: headers);

    try {
      if (response.body.isNotEmpty) {
        var jsonString = response.body;
        print(response.body);
        return checkApiResponseMFromJson(jsonString);
      } else {
        return null;
      }
    } catch (e) {}
  }
}
