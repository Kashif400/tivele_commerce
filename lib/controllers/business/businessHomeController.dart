import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/customer/customerHomeModel.dart';
import 'package:e_commerce_foods/services/customer/customerHomeService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessHomeController extends GetxController {
  Rx<CustomerHomeM> homeINfo = CustomerHomeM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCustomerHomeData("0");
  }

  void fetchCustomerHomeData(String pageNumber) async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await CustomerHomeService.fetchHomeData(pageNumber);
    if (detail == 600) {
      isLoading(false).obs;
      isListNull(true).obs;
      globals.showErrorSnackBar("No Data Found!");
    } else if (detail != null) {
      try {
        homeINfo.value = detail;
        if (homeINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
        } else if (homeINfo.value.status == 100) {
          isLoading(false).obs;
          isListNull(true).obs;
          globals.showErrorSnackBar(homeINfo.value.message!);
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
      isListNull(true).obs;
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
