import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/customer/updateUserPasswordService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUserPasswordController extends GetxController {
  Rx<CheckApiResponseM> passwordINfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  dynamic fetchUpdateUserPassword(Map<dynamic, dynamic> userData) async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail =
        await UpdateUserPasswordService.fetchUpdateUserPassword(userData);
    if (detail != null) {
      try {
        passwordINfo.value = detail;
        if (passwordINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
        } else if (passwordINfo.value.status == 900) {
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
