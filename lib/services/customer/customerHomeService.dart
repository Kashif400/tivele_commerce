import 'dart:convert';

import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerHomeService {
  static var client = http.Client();

  static Future fetchHomeData(String pageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    print(token.toString() + "TOKEN");
    Map<String, String> headers = {'Authorization': token};
    var response;
    try {
      response = await client.get(
          Uri.parse(
              URLS.BASEURL + URLS.get_timeline_data + "?page=" + pageNumber),
          headers: headers);
    } catch (e) {
      print("Header Excpetion: " + e.toString());
      return 600;
    }
    final requestbody = json.decode(response.body);
    try {
      if (response.body.isNotEmpty) {
        if (requestbody["status"] == 600) {
          return 600;
        } else {
          var jsonString = response.body;
          debugPrint("Product data");
          debugPrint(response.body, wrapWidth: 1024);
          return getExploreDataMFromJson(jsonString);
        }
      } else {
        return null;
      }
    } catch (e) {
      return 600;
    }
  }
}
