import 'dart:io';

import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileImageService {
  static var client = http.Client();
  static late String userUrl;
  static Future fetchUpdateProfileImage(
      File file, String filename, String userType) async {
    if (userType == "user") {
      userUrl = URLS.update_user_profile_image;
    } else if (userType == "business") {
      userUrl = URLS.update_business_profile_image;
    }
    print("filename:" + filename);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token")!;

    ///MultiPart request
    var request =
        http.MultipartRequest('POST', Uri.parse(URLS.BASEURL + userUrl));

    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Authorization': token
    };
    String mimeStr = lookupMimeType(file.path)!;
    final mimeTypedData = mimeStr.split('/');
    request.files.add(
      http.MultipartFile(
        'uploadImg',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
        contentType: MediaType(mimeTypedData[0], mimeTypedData[1]),
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    if (response.body.isNotEmpty) {
      var jsonString = response.body;
      print(response.body);
      return checkApiResponseMFromJson(jsonString);
    } else {
      print("error upload");
      Get.back();
      return null;
    }
  }
  // static Future fetchUpdateProfileImage(Map<dynamic, dynamic> userData) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token=prefs.getString("token");
  //   print(token);
  //   Map<String,String> headers ={
  //     'Authorization':token
  //   };
  //   print(userData);
  //   var response=await client.post(Uri.parse(URLS.BASEURL+URLS.update_user_profile_image),body: userData,headers: headers);
  //
  //   try {
  //     if(response.body.isNotEmpty){
  //       var jsonString=response.body;
  //       print(response.body);
  //       return checkApiResponseMFromJson(jsonString);
  //     }
  //     else{
  //       return null;
  //     }
  //   }catch (e) {
  //   }
  // }
}
