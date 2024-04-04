// import 'package:http_interceptor/http_interceptor.dart';

// class TokenAuthInterceptor implements InterceptorContract {
//   @override
//   Future<RequestData> interceptRequest({required RequestData data}) async {
//     print("interceptRequest is called");
//     return data;
//   }

//   @override
//   Future<ResponseData> interceptResponse({required ResponseData data}) async {
//       print("interceptResponse is called");
//       return data;
//   }

// }

import 'package:http_interceptor/http_interceptor.dart';

class TokenAuthInterceptor implements InterceptorContract {
  @override
  Future<bool> shouldInterceptRequest() async {
    // Return true if we should intercept the request
    return true;
  }

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    // Add auth token to request

    return request;
  }

  @override
  Future<bool> shouldInterceptResponse() async {
    // Return true if we should intercept the response
    return true;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    // Process response

    return response;
  }
}
