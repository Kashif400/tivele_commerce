import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';

class OrderReviewService {
  static var client = http.Client();

  static Future fetchOrderReview(Map<dynamic, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    print(token);
    Map<String, String> headers = {'Authorization': token};
    print(userData);
    var response = await client.post(
        Uri.parse(URLS.BASEURL + URLS.order_reviewed_by_user),
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
