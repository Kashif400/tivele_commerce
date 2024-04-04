import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:e_commerce_foods/models/BankCard/card.dart';
import 'package:e_commerce_foods/service/BankCard/card.dart';
import 'package:e_commerce_foods/service/product/product_service.dart';

class CardsProvider with ChangeNotifier {
  List<Card> _bankcard = [];
  Card? _bankcards;
  bool _productLoading = false;

  /// Get All getter & setter
  List<Card> get bankcard => _bankcard;

  set bankcard(List<Card> data) {
    this._bankcard = data;
    notifyListeners();
  }

  /// Get single getter & setter

  Card? get bankcards => _bankcards;

  set bankcards(Card? data) {
    this._bankcards = data;
    notifyListeners();
  }

  /// Get All Card function

  getCard() async {
    try {
      var res = await CardService.getAllById();
      bankcard = [];
      var list = _bankcard;

      for (var item in res["items"]) {
        var prod = Card.fromJson(item);
        list.add(prod);
      }
      bankcard = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// Get Single Product function

  getCards(String id) async {
    try {
      var prod = await CardService.get(id);
      var res = Card.fromJson(prod);
      bankcards = res;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// File Upload Funcation

  Future<String> productUpload(File file) async {
    try {
      var profileImageUrl = await ProductService.uploadProduct(file);
      // GlobalProperty.imageUrl = profileImageUrl;
      //await SessionService.setProfileImageUrl(profileImageUrl);
      return profileImageUrl.toString();
    } catch (err) {
      return err.toString();
    }
  }
}
