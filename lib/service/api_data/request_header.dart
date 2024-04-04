import "./api_keys.dart";

class RequestHeader {
  static getHeader() {
    print(APIKeys.accessToken);
    return {
      'Authorization': "Bearer ${APIKeys.accessToken}",
      'accept': 'application/json',
    };
  }

  static postHeader() {
    return {
      'Authorization': 'Bearer ${APIKeys.accessToken}',
      'content-type': 'application/json',
      'accept': 'application/json',
    };
  }

  static postImageHeader() {
    return {
      'Authorization': 'Bearer ${APIKeys.accessToken}',
      'content-type': 'image/jpg; image/png',
      'accept': 'application/json',
    };
  }

  static postWithoutTokenHeader() {
    return {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
  }

  static getAuthToken() {
    return 'Bearer ${APIKeys.accessToken}';
  }
}
