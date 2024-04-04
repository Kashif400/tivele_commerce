import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/driver/order_pickedBy_DriverService.dart';

class orderPickedByDriverController extends GetxController {
  var isLoading = false.obs;
  var isListNull = false.obs;
  Rx<CheckApiResponseM> orderINfo = CheckApiResponseM().obs;
  fetchorderpickedbydriver(String imgUrl, String? orderId) async {
    isLoading(true).obs;
    isListNull(true).obs;
    Map<String, String?> mapData = {
      "order_id": orderId,
      "pickup_image": imgUrl
    };
    var detail =
        await orderPickedByDriverService.fetchOrderPickedByDriver(mapData);

    print(detail.toString() + "detail hey ye");
    if (detail != null) {
      print("detail is not null");
      try {
        orderINfo.value = detail;

        if (orderINfo.value.status == 200) {
          print("ORDER PLACED SUCCESSFULLLLLLLLY");
          isLoading(false).obs;
          isListNull(false).obs;
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
