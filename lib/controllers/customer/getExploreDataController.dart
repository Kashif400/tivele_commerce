import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';
import 'package:e_commerce_foods/services/customer/getExploreDataService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetExploreDataController extends GetxController {
  Rx<GetExploreDataM> exploreINfo = GetExploreDataM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  dynamic fetchCustomerHomeData(String pageNumber, String longitude,
      String latitude, String categoryId) async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await GetExploreDataService.fetchExploreData(
        pageNumber, longitude, latitude, categoryId);
    if (detail == 600) {
      isLoading(false).obs;
      isListNull(true).obs;
      exploreINfo.value.status = 600;
      // globals.showErrorSnackBar("No Data Found!");
    } else if (detail != null) {
      try {
        exploreINfo.value = detail;
        if (exploreINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
        } else if (exploreINfo.value.status == 100) {
          isLoading(false).obs;
          isListNull(true).obs;
          //globals.showErrorSnackBar(exploreINfo.value.message);
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
