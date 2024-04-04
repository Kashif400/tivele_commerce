import 'dart:io';

import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/uploadVidService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadVidController extends GetxController {
  Rx<CheckApiResponseM> vidINfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  int index = 0;
  void fetchVid(File file, String filename, int checkApi, String name) async {
    isLoading(true).obs;
    var detail = await UploadVidService.fetchvid(file, filename);
    if (detail != null) {
      try {
        vidINfo.value = detail;
        if (vidINfo.value.status == 200) {
          isLoading(false).obs;
          if (checkApi == 0) {
            isLoading(false).obs;
            print("vid success uploadvidController");
            print(vidINfo.value.data);
          }
        } else if (vidINfo.value.status == 100) {
          isLoading(false).obs;
          Get.snackbar(
            "Error",
            "VIDEO Upload Error!!",
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
            "Video Upload Error!!",
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
          "Video Upload Error!!",
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
