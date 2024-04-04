import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/customer/getBusinessProfileByIdModel.dart';
import 'package:e_commerce_foods/services/customer/getBusinessProfileByIdService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetBusinessProfileByIdController extends GetxController {
  Rx<GetBusinessProfileByIdM> businessINfo = GetBusinessProfileByIdM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  void fetchGetBusinessProfileByIdData(String businessId) async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail =
        await GetBusinessProfileByIdService.fetchGetBusinessProfileByIdData(
            businessId);
    if (detail == 600) {
      isLoading(false).obs;
      isListNull(true).obs;
      businessINfo.value.status = 600;
      globals.showErrorSnackBar("No Data Found!");
    } else if (detail != null) {
      try {
        businessINfo.value = detail;
        if (businessINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
        } else if (businessINfo.value.status == 100) {
          isLoading(false).obs;
          isListNull(true).obs;
          globals.showErrorSnackBar(businessINfo.value.message!);
        } else {
          isLoading(false).obs;
          Get.snackbar(
            "Error!",
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
          "Error!",
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
        "Error!",
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
}
