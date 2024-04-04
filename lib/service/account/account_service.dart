import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:e_commerce_foods/service/token_auth/client_with_interceptor.dart';

import '../api_data/api_endpoint.dart';
import '../api_data/api_service.dart';
import "../api_data/request_header.dart";
import "../api_data/request_response.dart";

enum AccountEndPoint {
  register,
  emailVerification,
  emailRegister,
  forgetPassword,
  forgetPasswordCodeVerification,
  changePassword
}

class AccountService {
  APIService? apiService;
  static const String BASE_PATH = "services/app/account";

  static Map<AccountEndPoint, String> customPaths = {
    AccountEndPoint.register: 'Register',
    AccountEndPoint.emailVerification: 'EmailVerification',
    AccountEndPoint.emailRegister: 'EmailRegister',
    AccountEndPoint.forgetPassword: 'ForgetPassword',
    AccountEndPoint.forgetPasswordCodeVerification:
        'ForgetPasswordCodeVerification',
    AccountEndPoint.changePassword: "ChangePassword"
  };

  static Future<bool> registerEmail(String email) async {
    final response = await http.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH,
                customUrl: customPaths[AccountEndPoint.emailRegister])
            .toString()),
        headers: RequestHeader.postWithoutTokenHeader(),
        body: json.encode({"email": email}));

    return RequestResponse.getBoolResult(response);
  }

  static Future<String?> verifyEmail({String? email, String? code}) async {
    final response = await http.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH,
                customUrl: customPaths[AccountEndPoint.emailVerification])
            .toString()),
        headers: RequestHeader.postWithoutTokenHeader(),
        body: json.encode({"email": email, "code": code}));

    return RequestResponse.getResult(response);
  }

  static Future<bool> register(account) async {
    final response = await http.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH,
                customUrl: customPaths[AccountEndPoint.register])
            .toString()),
        headers: RequestHeader.postWithoutTokenHeader(),
        body: json.encode(account));

    return RequestResponse.getBoolResult(response);
  }

  static Future<bool> forgetPassword(String email) async {
    final response = await http.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH,
                customUrl: customPaths[AccountEndPoint.forgetPassword])
            .toString()),
        headers: RequestHeader.postWithoutTokenHeader(),
        body: json.encode({"email": email}));

    return RequestResponse.getBoolResult(response);
  }

  static Future<String?> forgetPassCodeVerif(
      {String? email, String? code}) async {
    final response = await http.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH,
                customUrl:
                    customPaths[AccountEndPoint.forgetPasswordCodeVerification])
            .toString()),
        headers: RequestHeader.postWithoutTokenHeader(),
        body: json.encode({"email": email, "code": code}));

    return RequestResponse.getResult(response);
  }

  static Future<bool> changePassword(account) async {
    final response = await http.post(
        Uri.parse(APIEndpoint.endPointUri(
                baseUrl: BASE_PATH,
                customUrl: customPaths[AccountEndPoint.changePassword])
            .toString()),
        headers: RequestHeader.postWithoutTokenHeader(),
        body: json.encode(account));

    return RequestResponse.getBoolResult(response);
  }

  static Future<dynamic> getAccounts(
      {isBroker, username, skipCount = 0, maxResultCount = 5}) async {
    final baseUrl = BASE_PATH;
    final customPath = 'GetAll';

    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          "?isBroker=$isBroker&SkipCount=$skipCount&MaxResultCount=$maxResultCount"),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }

  static Future<dynamic> getAccountById({id}) async {
    final baseUrl = BASE_PATH;
    final customPath = 'Get';

    final response = await ClientWithInterception.client.get(
      Uri.parse(APIEndpoint.endPointUri(baseUrl: baseUrl, customUrl: customPath)
              .toString() +
          "?id=$id"),
      headers: RequestHeader.getHeader(),
    );
    return RequestResponse.getResult(response);
  }
}
