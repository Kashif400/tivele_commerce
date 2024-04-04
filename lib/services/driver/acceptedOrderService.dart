import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';

class acceptedOrderService {
  static var client = http.Client();

  static Future fetchacceptedOrder(orderID) async {
    Map mapdetails = {"order_id": orderID};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    print(token.toString() + "**THIS IS TOKEN");
    Map<String, String> headers = {'Authorization': token};
    print(token);

    var response = await client.post(
        Uri.parse(URLS.BASEURL + URLS.accept_order_by_driver),
        body: mapdetails,
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
