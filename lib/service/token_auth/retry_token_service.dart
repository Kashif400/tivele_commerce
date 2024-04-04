import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/service/token_auth/token_auth_service.dart';

class RetryTokenService extends RetryPolicy {
  @override
  final int maxRetryAttempts = 3;
  @override
  Future<bool> shouldAttemptRetryOnResponse(http.BaseResponse response) async {
    if (response.statusCode == 401) {
      print("Refresh token");
      final normalLogIn = SessionService.isNormalLogIn();

      if (normalLogIn) {
        final account = {
          "userNameOrEmailAddress": SessionService.retrieveEmail(),
          "password": SessionService.retrievePassword(),
          "rememberClient": true
        };
        TokenAuthService.authenticate(account);

        return true;
      }

      return false;
    }

    return false;
  }
}
