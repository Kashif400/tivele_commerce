import 'dart:convert';

import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/loginModel.dart';
import 'package:e_commerce_foods/services/loginService.dart';
import 'package:e_commerce_foods/views/business/businessProfilePage.dart';
import 'package:e_commerce_foods/views/customer/customerHomePage.dart';
import 'package:e_commerce_foods/views/customer/verificaionCodePage.dart';
import 'package:e_commerce_foods/views/driver/driverHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  Rx<LoginM> loginINfo = LoginM().obs;
  var isLoading = false.obs;
  dynamic fetchLogin(
      Map<String, Object> userData, int checkApi, bool remember) async {
    print("fetching  loginnnnnnnnnnnnnnnnnnnnnnnnnnn");
    isLoading(true).obs;
    var detail = await LoginService.fetchLogin(userData);
    print(
        "fetching  loginnnnnnnnnnnnnnnnnnnnnnnnnnn downnnnnnnnnnnnnnnnnnnnnnnnnnn");

    if (detail["status"] == 100) {
      print("erorrrr 10000000000000000000000000");

      isLoading(false).obs;
      globals.showErrorSnackBar("Invalid email or password!");
    } else if (detail["status"] == 701) {
      print("erorrrr 700000000000000000000000001");

      isLoading(false).obs;
      showLoginErrorDialog();
    } else if (detail["status"] == 702) {
      print("erorrrr 700000000000000000000000001");

      isLoading(false).obs;
      Get.offAll(VerificationCodePage(),
          arguments: [detail["data"], userData["email"]]);
    } else if (detail != null) {
      print("loginnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
      try {
        final requestbody = json.encode(detail);
        var jsonString = requestbody;
        loginINfo.value = loginMFromJson(jsonString);
        if (loginINfo.value.status == 200) {
          print("erorrrr 20000000000000000000000000");

          globals.checkLogin = false;
          if (checkApi == 0) {
            isLoading(false).obs;
            print("check Api  == 0000000000000000000000000000000000");

            if (remember) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("loggedIn", true);
              prefs.setString("user_id", loginINfo.value.data!.userId!);
              prefs.setString("email", loginINfo.value.data!.userEmail!);
              prefs.setString("user_name", loginINfo.value.data!.userName!);
              prefs.setString("user_type", loginINfo.value.data!.userType!);
              prefs.setString("token", loginINfo.value.token!);
              prefs.setString("user_image", loginINfo.value.data!.userImage!);
              globals.showSuccesSnackBar(loginINfo.value.message!);
              Get.offAll(CustomerHomePage());
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("loggedIn", false);
              prefs.setString("user_id", loginINfo.value.data!.userId!);
              prefs.setString("email", loginINfo.value.data!.userEmail!);
              prefs.setString("user_name", loginINfo.value.data!.userName!);
              prefs.setString("user_type", loginINfo.value.data!.userType!);
              prefs.setString("token", loginINfo.value.token!);
              prefs.setString("user_image", loginINfo.value.data!.userImage!);
              globals.showSuccesSnackBar(loginINfo.value.message!);
              Get.offAll(CustomerHomePage());
            }
          }
          if (checkApi == 1) {
            isLoading(false).obs;
            if (remember) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("loggedIn", true);
              prefs.setString("user_id", loginINfo.value.data!.userId!);
              prefs.setString("email", loginINfo.value.data!.userEmail!);
              prefs.setString("user_name", loginINfo.value.data!.userName!);
              prefs.setString("user_type", loginINfo.value.data!.userType!);
              prefs.setString("token", loginINfo.value.token!);
              prefs.setString("user_image", loginINfo.value.data!.userImage!);
              globals.showSuccesSnackBar(loginINfo.value.message!);
              Get.offAll(BusinessProfilePage());
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("loggedIn", false);
              prefs.setString("user_id", loginINfo.value.data!.userId!);
              prefs.setString("email", loginINfo.value.data!.userEmail!);
              prefs.setString("user_name", loginINfo.value.data!.userName!);
              prefs.setString("user_type", loginINfo.value.data!.userType!);
              prefs.setString("token", loginINfo.value.token!);
              prefs.setString("user_image", loginINfo.value.data!.userImage!);
              globals.showSuccesSnackBar(loginINfo.value.message!);
              Get.offAll(BusinessProfilePage());
            }
          }
          if (checkApi == 2) {
            isLoading(false).obs;
            if (remember) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("loggedIn", true);
              prefs.setString("user_id", loginINfo.value.data!.userId!);
              prefs.setString("email", loginINfo.value.data!.userEmail!);
              prefs.setString("user_name", loginINfo.value.data!.userName!);
              prefs.setString("user_type", loginINfo.value.data!.userType!);
              prefs.setString("token", loginINfo.value.token!);
              prefs.setString("user_image", loginINfo.value.data!.userImage!);

              globals.showSuccesSnackBar(loginINfo.value.message!);
              Get.offAll(DriverHomePage());
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("loggedIn", false);
              prefs.setString("user_id", loginINfo.value.data!.userId!);
              prefs.setString("email", loginINfo.value.data!.userEmail!);
              prefs.setString("user_name", loginINfo.value.data!.userName!);
              prefs.setString("user_type", loginINfo.value.data!.userType!);
              prefs.setString("token", loginINfo.value.token!);
              prefs.setString("user_image", loginINfo.value.data!.userImage!);
              globals.showSuccesSnackBar(loginINfo.value.message!);
              Get.offAll(DriverHomePage());
            }
          }
        } else if (loginINfo.value.status == 100) {
          isLoading(false).obs;
          globals.showErrorSnackBar(loginINfo.value.message!);
        } else {
          isLoading(false).obs;
          Get.snackbar(
            "Error Registration!",
            "Credentials not correct or user inactive 1",
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print(e);
        isLoading(false).obs;
        Get.snackbar(
          "Error Registration!",
          "Credentials not correct or user inactive 2",
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );

        // TODO
      }
    } else {
      isLoading(false).obs;
      Get.snackbar(
        "Error Registration!",
        "Credentials not correct or user inactive 3",
        icon: Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void showLoginErrorDialog() async {
    showAnimatedDialog(
      animationType: DialogTransitionType.sizeFade,
      curve: Curves.easeInCirc,
      duration: Duration(seconds: 1),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Text(
                        'Failed!',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            "Your account is under review.",
                            textAlign: TextAlign.center,
                            style: Global.style(
                              size: 20,
                              bold: true,
                              caps: true,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Please try again later.",
                            textAlign: TextAlign.center,
                            style: Global.style(
                              size: 14,
                              bold: true,
                              caps: false,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Ok',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
      context: Get.context!,
    );
  }
}
