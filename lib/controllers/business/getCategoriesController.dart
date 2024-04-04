import 'package:e_commerce_foods/models/business/getCategoriesModel.dart';
import 'package:e_commerce_foods/services/business/getCategoriesService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetCategoriesController extends GetxController {
  Rx<GetCategoriesM> categoryINfo = GetCategoriesM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await GetCategoriesService.fetchCategoryData();
    if (detail != null) {
      try {
        categoryINfo.value = detail;
        if (categoryINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
        } else if (categoryINfo.value.status == 100) {
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
