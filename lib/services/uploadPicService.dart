import 'dart:io';

import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UploadPicService {
  static Future fetchpic(File file, String filename) async {
    print("filename:" + filename);

    ///MultiPart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(URLS.BASEURL + URLS.upload_image),
    );

    Map<String, String> headers = {"Content-type": "multipart/form-data"};
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
}

// class UploadPicService {
//   static var client = http.Client();
//
//   static Future fetchpic(String picture) async {
//     Map userPic={
//       'uploadImg': picture,
//     };
//     print(userPic);
//     var response=await client.post(Uri.parse(URLS.BASEURL+URLS.uploadImage),body: userPic);
//
//     try {
//       if(response.body.isNotEmpty){
//         var jsonString=response.body;
//         print(response.body);
//         return uploadPicFromJson(jsonString);
//       }
//       else{
//         return null;
//       }
//     }catch (e) {
//     }
//   }
// }
