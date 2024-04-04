import 'dart:io';

import 'package:e_commerce_foods/models/product/SingleProduct.dart';
import 'package:e_commerce_foods/models/product/products.dart';
import 'package:e_commerce_foods/service/product/product_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class ProductsProvider with ChangeNotifier {
  List<Items> _product = [];
  SingleProduct? _singleProduct;
  List<Items> _productlikebyUser = [];
  List<Items> _productbyDistance = [];
  List<Items> _productbyCategory = [];
  Items? _products;
  bool? _productLoading;
  bool? _isSelected;

  bool? get ProductLoading => _productLoading;
  set ProductLoading(bool? data) {
    this._productLoading = data;
    notifyListeners();
  }

  bool? get isSelected => _isSelected;
  set isSelected(bool? value) {
    this._productLoading = value;
    notifyListeners();
  }

  /// get single Product
  SingleProduct? get singleProduct => _singleProduct;

  set singleProduct(SingleProduct? data) {
    this._singleProduct = data;
    notifyListeners();
  }

  /// get All ProductbyCategory

  List<Items> get productbyCategory => _productbyCategory;

  set productbyCategory(List<Items> data) {
    this._productbyCategory = data;
    notifyListeners();
  }

  ///Get All productLikeListbyUser

  List<Items> get productlikebyUser => _productlikebyUser;

  set productlikebyUser(List<Items> data) {
    this._productlikebyUser = data;
    notifyListeners();
  }

  /// get All product by distance
  List<Items> get productbyDistance => _productbyDistance;

  set productbyDistance(List<Items> data) {
    this._productbyDistance = data;
    notifyListeners();
  }

  /// Get All getter & setter

  List<Items> get product => _product;

  set product(List<Items> products) {
    this._product = products;
    notifyListeners();
  }

  /// Get single getter & setter

  Items? get products => _products;

  set products(Items? data) {
    this._products = data;
    notifyListeners();
  }

  getSingleProduct(prodId) async {
    try {
      singleProduct = null;
      var res = await ProductService.get(prodId);
      if (res != null) {
        var prod = SingleProduct.fromJson(res);
        singleProduct = prod;
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// Get All Product function

  // getProduct() async {
  //   try {
  //     var myId = await SessionService.retrieveUser();
  //     var res = await ProductService.FollowedProductByUser(myId);
  //     product = [];
  //     var list = _product;
  //
  //     for (var item in res["items"]) {
  //       var prod = Items.fromJson(item);
  //       list.add(prod);
  //     }
  //     product = list;
  //   }
  //   catch (err) {
  //     print(err);
  //   }
  //   notifyListeners();
  // }
  getProductByBusiness(myId) async {
    try {
      // var myId = await SessionService.retrieveUser();
      var res = await ProductService.ProductsByBusinessAccount(myId);
      product = [];
      var list = _product;

      for (var item in res["items"]) {
        var prod = Items.fromJson(item);
        list.add(prod);
      }
      product = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// Get Single Product function

  getProducts(String? id) async {
    try {
      var prod = await ProductService.get(id);
      var res = Items.fromJson(prod);
      products = res;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  getProduct() async {
    try {
      var myId = await SessionService.retrieveUser();
      var res = await ProductService.FollowedProductByUser(myId);
      // ProductsByBusinessAccount(myId);
      product = [];
      var list = _product;
      for (var item in res["items"]) {
        var prod = Items.fromJson(item);
        list.add(prod);
      }
      product = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// File Upload Funcation

  Future<dynamic> productUpload(File file) async {
    try {
      var profileData = await ProductService.uploadProduct(file);
      // GlobalProperty.imageUrl = profileImageUrl;
      //await SessionService.setProfileImageUrl(profileImageUrl);
      return profileData;
    } catch (err) {
      return err;
    }
  }

  Future<dynamic> productUpload2(List<String> profileImages) async {
    print("productUpload2");
    try {
      var profileData = await ProductService.uploadProduct2(profileImages);
      // GlobalProperty.imageUrl = profileImageUrl;
      //await SessionService.setProfileImageUrl(profileImageUrl);
      return profileData;
    } catch (err) {
      return err;
    }
  }

  getProductLikeByUser() async {
    try {
      var userId = await SessionService.retrieveUser();
      var res = await ProductService.getProductLikebyUser(userId);
      productlikebyUser = [];
      var list = _productlikebyUser;

      for (var item in res) {
        var prod = Items.fromJson(item);
        list.add(prod);
      }
      productlikebyUser = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  getProductbyLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var res = await ProductService.getProductbyDistance(
          Longitude: position.longitude,
          Latitude: position.latitude,
          DistanceEnum: 25);
      _productbyDistance = [];
      var list = _productbyDistance;
      for (var item in res["items"]) {
        var prod = Items.fromJson(item);
        list.add(prod);
      }
      productbyDistance = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  getProductbyCategoryId(String? categoryId) async {
    try {
      var prod = await ProductService.getProductbyCategory(categoryId);
      productbyCategory = [];
      var list = _productbyCategory;

      for (var item in prod["items"]) {
        var prod = Items.fromJson(item);
        list.add(prod);
      }
      productbyCategory = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }
}

 /* Future<bool> updateCurrentUserProfile(Account user) async {
    final req = {
      'title': user.title,
      'name': user.name,
      'address': user.address,
      'insurerNo': user.insurerNo,
      'bio': user.bio,
      'dataOfBirth':user.dateOfBirth.toIso8601String()
    };
    var res = await UserService.updateProfile(req);
    if (res) {
      getCurrentUser();
    }
    return res;
  }*/

 /* Future<bool> saveProfilePicture(File file) async {
    try {
      var profileImageUrl = await UserService.saveProfilePicture(file);
      // GlobalProperty.imageUrl = profileImageUrl;
      await SessionService.setProfileImageUrl(profileImageUrl);
      return profileImageUrl != null;
    } catch (err) {
      return err;
    }
  }*/

  /*Future<bool> uploadFile(File file , String offerid) async {
    try {
      var imageUrl = await FileService.attachToMsgOrOffer(attachment: file,offerId: offerid);
      // GlobalProperty.imageUrl = profileImageUrl;
      if(imageUrl != null){
        String fileName = imageUrl['fileName'];
        GlobalProperties.attachmentId = imageUrl['id'];
        GlobalProperties.content = "Name: $fileName\nfile attached with this message";
        return true;
      }
      else{
        return false;
      }
    } catch (err) {
      return err;
    }
  }*/
/*
  Future<bool> getFile(String fileId) async {
    try {
      var imageUrl = await FileService.attachToMsgOrOffer(attachment: file,offerId: offerid);
      // GlobalProperty.imageUrl = profileImageUrl;
      return imageUrl != null;
    } catch (err) {
      return err;
    }
  }*/
//  Future<bool> getProfilePicture(File file) async {
//    try {
//      var res = await UserService.getProfilePicture();
//      return res != null;
//    } catch (err) {
//      return false;
//    }
//  }

 /* Future<bool> login(dynamic account) async {
    var res = await TokenAuthService.authenticate(account);
    await GlobalProperties.getProfileImageUrl();
    this.getCurrentUser();
    return res;
  }

  Future<bool> externalLogin({
    authProvider,
    providerKey,
    providerAccessCode,
  }) async {
    var res = await TokenAuthService.externalAuthenticate(authProvider: authProvider, providerKey: providerKey, providerAccessCode: providerAccessCode);
    this.getCurrentUser();
    return res;
  }

  Future<bool> GetNotifications() async {
    try {
      var email = await SessionService.retrieveEmail();
      var password = await SessionService.retrievePassword();
      dynamic account = {'userNameOrEmailAddress': email, 'password': password};
      var res = await this.login(account);
      await GlobalProperties.getProfileImageUrl();
      return res;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> loginWithSavedData() async {
    try {
      var email = await SessionService.retrieveEmail();
      var password = await SessionService.retrievePassword();
      dynamic account = {'userNameOrEmailAddress': email, 'password': password};
      var res = await this.login(account);
      await GlobalProperties.getProfileImageUrl();
      return res;
    } catch (err) {
      print(err);
      return false;
    }
  }
  Future<bool> loginWithSavedexternalAuthenticate() async {
    try {
      var authProvider = await SessionService.authProvider();
      var providerKey = await SessionService.providerKey();
      var providerAccessCode = await SessionService.providerAccessCode();
      var res = await this.externalLogin(authProvider: authProvider,
          providerKey: providerKey, providerAccessCode: providerAccessCode);
      return res;
    }catch(err) {
      print(err);
      return false;
    }
  }

  Future<void> getSearchedBrokers(String req) async {
    try {
      var res =
      await AccountService.getAccounts(isBroker: false, username: req);
      this.usersSearchResult = res['items'];
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  setNewUserIsBroker(bool value) {
    this.newUserIsBroker = value;
    notifyListeners();
  }
}*/
