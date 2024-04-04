import 'dart:convert';
import 'package:e_commerce_foods/models/business/businessPofileM.dart';
import 'package:e_commerce_foods/models/business/businessProfileEmptyProductM.dart';
import 'package:e_commerce_foods/services/business/businessProfileService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessProfileController extends GetxController {
  Rx<BusinessProfileM?> profileINfo = BusinessProfileM().obs;
  Rx<BusinessProfileEmptyProductM> profileEmptyINfo =
      BusinessProfileEmptyProductM().obs;
  var isLoading = true.obs;
  var isListNull = false.obs;
  void fetchBusinessProfile() async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await BusinessProfileService.fetchProfileData();
    print("ali1234");
    final checkDetail = json.decode(detail);
    if (detail != null) {
      if (checkDetail["products"] != []) {
        print("products");
        profileINfo.value = businessProfileMFromJson(detail);
        try {
          //profileINfo.value = detail;
          if (profileINfo.value!.status == 200) {
            isLoading(false).obs;
            isListNull(false).obs;
          } else if (profileINfo.value!.status == 100) {
            isLoading(false).obs;
            isListNull(true).obs;
          } else {
            isLoading(false).obs;
            isListNull(true).obs;
          }
        } catch (e) {
          print(e.toString());
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
        profileEmptyINfo.value = businessProfileEmptyProductMFromJson(detail);
        profileINfo.value = null;
        try {
          //profileINfo.value = detail;
          if (profileEmptyINfo.value.status == 200) {
            isLoading(false).obs;
            isListNull(false).obs;
          } else if (profileEmptyINfo.value.status == 100) {
            isLoading(false).obs;
            isListNull(true).obs;
          } else {
            isLoading(false).obs;
            isListNull(true).obs;
          }
        } catch (e) {
          print(e.toString());
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
