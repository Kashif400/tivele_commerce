import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/customer/orderReviewService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderReviewController extends GetxController {
  Rx<CheckApiResponseM> orderReviewINfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  dynamic fetchOrderReview(Map<dynamic, dynamic> userData) async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await OrderReviewService.fetchOrderReview(userData);
    if (detail != null) {
      try {
        orderReviewINfo.value = detail;
        if (orderReviewINfo.value.status == 200) {
          isLoading(false).obs;
          globals.showSuccessToast("Review added successfully.");
        } else if (orderReviewINfo.value.status == 700) {
          isLoading(false).obs;
          globals.showErrorToast("Already Reviewd!");
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
