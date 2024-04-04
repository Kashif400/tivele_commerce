import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';

import '../api_data/api_endpoint.dart';
import '../api_data/api_keys.dart';
import '../api_data/request_header.dart';
import '../api_data/request_response.dart';

enum TokenAuthPoint { authenticate, externalAuthenticate }

class TokenAuthService {
  static const String BASE_PATH = "tokenAuth";

  static Map<TokenAuthPoint, String> customPaths = {
    TokenAuthPoint.authenticate: 'Authenticate',
    TokenAuthPoint.externalAuthenticate: 'ExternalAuthenticate'
  };

  static Future<bool> authenticate(account) async {
    final response = await http.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH,
                customUrl: customPaths[TokenAuthPoint.authenticate])
            .toString()),
        headers: RequestHeader.postWithoutTokenHeader(),
        body: json.encode(account));

    final result = RequestResponse.getResult(response);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loggedIn", true);
    await prefs.setString("EMAIL_USER", account['userNameOrEmailAddress']);
    await prefs.setString("PASSWORD_USER", account['password']);
    print("user123");
    SessionService.addEmailAndPassword(
        account['userNameOrEmailAddress'], account['password']);
    SessionService.setProfileImageUrl(result['profileImageUrl']);
    SessionService.addUser(result["userId"]);
    return addAccessToken(result);
  }

  static Future<bool> externalAuthenticate(
      {authProvider, providerKey, providerAccessCode}) async {
    final response = await http.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH,
                customUrl: customPaths[TokenAuthPoint.externalAuthenticate])
            .toString()),
        headers: RequestHeader.postWithoutTokenHeader(),
        body: json.encode({
          "authProvider": authProvider,
          "providerKey": providerKey,
          "providerAccessCode": providerAccessCode
        }));

    final result = RequestResponse.getResult(response);
    SessionService.addExternalAuthenticateData(
        authProvider, providerKey, providerAccessCode);
    return addAccessToken(result);
  }

  static bool addAccessToken(result) {
    final accessToken = result['accessToken'];

    if (accessToken != null) {
      APIKeys.accessToken = accessToken;
      APIKeys.expiredTime = new DateTime.now().add(new Duration(days: 1));
      return true;
    }
    return false;
  }

  static bool isTokenExpired() {
    final compResult = APIKeys.expiredTime.compareTo(new DateTime.now());
    if (compResult > 0) {
      return false;
    }
    return true;
  }
}
