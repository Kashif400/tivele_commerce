import 'dart:convert';

class RequestResponse {
  static dynamic getResult(response) {
    if (response.statusCode == 200) {
      final requestbody = json.decode(response.body);
      final data = requestbody['result'];
      return data;
    }

    print(
        "failed \n Response: ${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }

  static dynamic getBoolResult(response) {
    if (response.statusCode == 200) {
      final requestbody = json.decode(response.body);
      final data = requestbody['result'];
      print("mydata");
      print(data);
      return true;
    }

    print(
        "failed \n Response: ${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }

  static dynamic getFollowResult(response) {
    print("follow error here (rquest_response) page");
    if (response.statusCode == 200) {
      print("if case rqst-response page");
      final requestbody = json.decode(response.body);
      final data = requestbody['result'];
      return data;
    }
    print("else case rqst-response page");
    print(
        "failed \n Response: ${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }

  static dynamic getUploadPicResult(response) {
    print("picssssssssssssssssssss");
    if (response.statusCode == 200) {
      final requestbody = json.decode(response.body);
      print(requestbody);
      final data = requestbody;
      return data;
    }

    print(
        "failed \n Response: ${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }

  static dynamic getFileResult(response) {
    if (response.statusCode == 200) {
      final requestbody = json.decode(response.body);
      final data = requestbody['result'];
      print("ijk");
      print(data);
      return data;
    }
    if (response.statusCode == 401) {
      //@todo:refresh token
    }

    print(
        "failed \n Response: ${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }
}
