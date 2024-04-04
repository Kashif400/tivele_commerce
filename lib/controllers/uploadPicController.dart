import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/uploadPicService.dart';

class UploadPicController extends GetxController {
  Rx<CheckApiResponseM> picINfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  int index = 0;
  dynamic fetchPic(
      File file, String filename, int checkApi, String name) async {
    isLoading(true).obs;
    var detail = await UploadPicService.fetchpic(file, filename);
    if (detail != null) {
      try {
        picINfo.value = detail;
        if (picINfo.value.status == 200) {
          isLoading(false).obs;
          if (checkApi == 0) {
            isLoading(false).obs;
            print("ali");
            print(picINfo.value.data);
          }
        } else if (picINfo.value.status == 100) {
          isLoading(false).obs;
          Get.snackbar(
            "Error",
            "Picture Upload Error!!",
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          isLoading(false).obs;
          Get.snackbar(
            "Error",
            "Picture Upload Error!!",
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print(e);
        isLoading(false).obs;
        Get.snackbar(
          "Error",
          "Picture Upload Error!!",
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
