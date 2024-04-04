import 'package:flutter/cupertino.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';

class GlobalProperties with ChangeNotifier {
  static String? defaultProfileImageUrl =
      "https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg";

  static bool queAsked = true;
  static bool updateAllOffers = false;
  static String? allOffersScreen;
  static String? requestId;
  static String? offerId;
  static String? profileImageUrl = defaultProfileImageUrl;
  static int? brokerId;
  static int? clientId;
  static String? content;
  static String? attachmentId;
  static var file;

  static void getProfileImageUrl() async {
    var imageUrl = await SessionService.retrieveProfileImageUrl();
    profileImageUrl =
        imageUrl?.isEmpty ?? true ? defaultProfileImageUrl : imageUrl;
  }
}
