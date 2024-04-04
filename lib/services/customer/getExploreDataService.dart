import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';

class GetExploreDataService {
  static var client = http.Client();

  static Future fetchExploreData(String pageNumber, String longitude,
      String latitude, String categoryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    print(token);
    print(pageNumber);
    print(longitude);
    print(latitude);
    print(categoryId);
    Map<String, String> headers = {'Authorization': token};
    var response = await client.get(
        Uri.parse(URLS.BASEURL +
            URLS.get_explore +
            "?page=" +
            pageNumber +
            "&longitude=" +
            longitude +
            "&latitude=" +
            latitude +
            "&category_id=" +
            categoryId),
        headers: headers);
    final requestbody = json.decode(response.body);
    try {
      if (response.body.isNotEmpty) {
        if (requestbody["status"] == 600) {
          return 600;
        } else {
          var jsonString = response.body;
          print(response.body);
          return getExploreDataMFromJson(jsonString);
        }
      } else {
        return null;
      }
    } catch (e) {}
  }
}
