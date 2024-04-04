import 'dart:convert';

import 'package:e_commerce_foods/URLS.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static var client = http.Client();

  static Future fetchLogin(Map<String, Object> userData) async {
    print("fetch api ");
    var response =
        await client.post(Uri.parse(URLS.BASEURL + URLS.login), body: userData);
    print("fetch api 2");
    final requestbody = json.decode(response.body);

    // final requestbody = jsonDecode(json.decode(response.body));

    print("fetch api 3 ");
    try {
      if (response.body.isNotEmpty) {
        if (requestbody["status"] == 100) {
          print(" fetch page erorrrr 10000000000000000000000000");

          return requestbody;
        } else if (requestbody["status"] == 701) {
          print(" fetch page erorrrr 700000000000000000000000001");

          return requestbody;
        } else if (requestbody["status"] == 702) {
          print(" fetch page erorrrr 700000000000000000000000002");

          return requestbody;
        } else {
          // var jsonString = response.body;
          // print(response.body);

          // return loginMFromJson(jsonString);
          print(" fetch page elseeeeeeeeeeeeeeeeeeeeeeeeeeeeee");

          return requestbody;
        }
      } else {
        print(" fetch page elseeeeeeeee nulllllllllllllllllll");

        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
