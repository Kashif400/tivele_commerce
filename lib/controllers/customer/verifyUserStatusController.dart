import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/customer/veryUserStatusService.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyUserController extends GetxController {
  Rx<CheckApiResponseM> verificationINfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  void fetchUpdateUserData(Map<dynamic, dynamic> userData) async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await VerifyUserService.fetchUpdateUser(userData);
    if (detail != null) {
      try {
        verificationINfo.value = detail;
        if (verificationINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
          Get.offAll(CustomerLoginPage());
        } else if (verificationINfo.value.status == 900) {
          isLoading(false).obs;
          isListNull(false).obs;
        } else {
          isLoading(false).obs;
          isListNull(true).obs;
        }
      } catch (e) {
        print(e);
        isLoading(false).obs;
        isListNull(false).obs;
        Get.snackbar(
          "Error",
          "Data is not getting!",
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        // TODO
      }
    } else {
      isLoading(false).obs;
      isListNull(false).obs;
      Get.snackbar(
        "Error",
        "User inactive",
        icon: Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    }
  }
}
