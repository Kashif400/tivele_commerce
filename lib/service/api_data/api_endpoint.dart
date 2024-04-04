import './api_keys.dart';

class APIEndpoint {
  static Uri endPointUri({baseUrl, customUrl}) {
    return Uri(
      scheme: 'https',
      host: APIKeys.host,
      path: APIKeys.basePath + '/$baseUrl/$customUrl',
    );
  }
}
