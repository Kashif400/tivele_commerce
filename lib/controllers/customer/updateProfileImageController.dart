import 'dart:io';

import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/customer/updateProfileImageService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileImageController extends GetxController {
  Rx<CheckApiResponseM> imageINfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  dynamic fetchUpdateImageData(
      File file, String filename, String userType) async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await UpdateProfileImageService.fetchUpdateProfileImage(
        file, filename, userType);
    if (detail != null) {
      try {
        imageINfo.value = detail;
        if (imageINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
        } else if (imageINfo.value.status == 100) {
          isLoading(false).obs;
          isListNull(true).obs;
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
