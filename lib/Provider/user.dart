import 'package:flutter/cupertino.dart';
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';
import 'package:e_commerce_foods/models/Profile/userProfile.dart';
import 'package:e_commerce_foods/models/User/user.dart';
import 'package:e_commerce_foods/service/BussinessUser/BusinessUser_service.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/service/token_auth/token_auth_service.dart';

class BusinessUsersProvider with ChangeNotifier {
  List<User> _user = [];
  User? _users;
  String? BusinessAccountId;
  UserProfile? _userProfile;
  bool _productLoading = false;

  /// Get All getter & setter

  List<User> get user => _user;

  set user(List<User> data) {
    this._user = data;
    notifyListeners();
  }

  /// Get single getter & setter

  User? get users => _users;

  set users(User? data) {
    this._users = data;
    notifyListeners();
  }

  ///get User Profile getter & setter

  UserProfile? get userProfile => _userProfile;

  set userProfile(UserProfile? data) {
    this._userProfile = data;
    notifyListeners();
  }

  /// Get All Product function

  getBussinessUser() async {
    try {
      var res = await BusinessUserService.getAll();
      user = [];
      var list = _user;

      for (var item in res["items"]) {
        var prod = User.fromJson(item);
        list.add(prod);
      }
      user = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  ///get User Profile

  getCurrentUser() async {
    try {
      var res = await UserProfileService.getProfile();
      var prod = UserProfile.fromJson(res);
      userProfile = prod;
    } catch (err) {
      print(err);
    }
  }

  /// Get Single Product function

  getBussinessUsers(String ID) async {
    try {
      await SessionService.addBusinessAccountId(ID);
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String businessAccountId= await prefs.getString("BusinessAccountId");
      var prod = await BusinessUserService.get(ID);
      var res = User.fromJson(prod);
      users = res;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// login
  Future<bool> login(dynamic account) async {
    var res = await TokenAuthService.authenticate(account);
    GlobalProperties.getProfileImageUrl();
    this.getCurrentUser();
    return res;
  }
}
