import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:e_commerce_foods/service/token_auth/retry_token_service.dart';
import 'package:e_commerce_foods/service/token_auth/token_auth_interceptor.dart';

abstract class ClientWithInterception {
  static http.Client client = InterceptedClient.build(
      interceptors: [TokenAuthInterceptor()], retryPolicy: RetryTokenService());
}
