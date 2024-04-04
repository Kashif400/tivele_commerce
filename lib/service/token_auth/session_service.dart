import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';

class SessionService {
  static addUser(userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  static addDriverAccountId(DriverAccountId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('DriverAccountID', DriverAccountId);
  }

  static addBusinessAccountId(BusinessAccountId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('BusinessAccountId', BusinessAccountId);
  }

  static retrieveDriverAccountId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("DriverAccountID");
  }

  static retrieveBusinessAccountId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("BusinessAccountId");
  }

  static dynamic retrieveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  static dynamic retrieveUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  static addEmailAndPassword(email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("email")) prefs.setString("email", email);
    if (!prefs.containsKey("password")) prefs.setString("password", password);
    if (!prefs.containsKey("normalLogIn")) prefs.setBool("normalLogIn", true);
  }

  static addExternalAuthenticateData(
      authProvider, providerKey, providerAccessCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("authProvider"))
      prefs.setString("authProvider", authProvider);
    if (!prefs.containsKey("providerKey"))
      prefs.setString("providerKey", providerKey);
    if (!prefs.containsKey("providerAccessCode"))
      prefs.setString("providerAccessCode", providerAccessCode);
    if (!prefs.containsKey("normalLogIn")) prefs.setBool("normalLogIn", true);
  }

  static retrieveEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  static retrievePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("password");
  }

  static authProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("authProvider");
  }

  static providerKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("providerKey");
  }

  static providerAccessCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("providerAccessCode");
  }

  static removePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove("password");
  }

  static retrieveProfileImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("profileImageUrl");
  }

  static setProfileImageUrl(profileImageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("profileImageUrl", profileImageUrl);
    GlobalProperties.profileImageUrl = profileImageUrl;
  }

  static removeEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove("email");
  }

  static dynamic isNormalLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("normalLogIn");
  }
}
