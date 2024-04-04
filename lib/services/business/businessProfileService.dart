import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/URLS.dart';

class BusinessProfileService {
  static var client = http.Client();

  static Future fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;
    print("TOKEN: " + token);
    Map<String, String> headers = {'Authorization': token};
    var response = await client
        .get(Uri.parse(URLS.BASEURL + URLS.business_profile), headers: headers);
    try {
      if (response.body.isNotEmpty) {
        var jsonString = response.body;
        print(response.body.toString() + "BOOOODY");
        return jsonString;
      } else {
        return null;
      }
    } catch (e) {}
  }
}
