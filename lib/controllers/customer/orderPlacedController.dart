import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/customer/orderPlacedService.dart';
import 'package:e_commerce_foods/views/customer/thankyouPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPlacedController extends GetxController {
  Rx<CheckApiResponseM> orderINfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  dynamic fetchOrderPlaced(Map<dynamic, dynamic> userData) async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await OrderPlacedService.fetchOrderPlaced(userData);
    if (detail != null) {
      try {
        orderINfo.value = detail;
        if (orderINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
          Get.offAll(ThankyouPage());
        } else if (orderINfo.value.status == 600) {
          isLoading(false).obs;
          isListNull(false).obs;
          globals.showErrorSnackBar("Not Subitted Data!");
        } else {
          isLoading(false).obs;
          isListNull(true).obs;
          globals.showErrorSnackBar("Not Subitted Data!");
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
