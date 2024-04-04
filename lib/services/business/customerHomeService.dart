import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/models/customer/customerHomeModel.dart';

class BusinessHomeService {
  static var client = http.Client();

  static Future fetchHomeData(String pageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    print(token.toString() + "TOKEN");
    Map<String, String> headers = {'Authorization': token};
    var response = await client.get(
        Uri.parse(
            URLS.BASEURL + URLS.get_timeline_data + "?page=" + pageNumber),
        headers: headers);
    final requestbody = json.decode(response.body);
    try {
      if (response.body.isNotEmpty) {
        if (requestbody["status"] == 600) {
          return 600;
        } else {
          var jsonString = response.body;
          print(response.body);
          return customerHomeMFromJson(jsonString);
        }
      } else {
        return null;
      }
    } catch (e) {}
  }
}
