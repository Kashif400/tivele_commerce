import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/ordersModel.dart';
import 'package:e_commerce_foods/services/driver/get_orders_by_driver_idService.dart';

class GetOrderByIdController extends GetxController {
  Rx<OrderServiceModel> userINfo = OrderServiceModel().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  List<Datum> completedOrders = [];
  List<Datum> get getDriverOrders => completedOrders;
  //var businessINfo = GetBusinessProfileByIdM().obs;

  Future fetchgetorderbyid() async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail =
        await get_orders_by_driver_idService.fetchGetOrdersByDriverId();
    if (detail == 600) {
      isLoading(false).obs;
      isListNull(true).obs;
      userINfo.value.status = 600;
      globals.showErrorSnackBar("No Data Found!");
    } else if (detail != null) {
      try {
        userINfo.value = detail;
        if (userINfo.value.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
          print("YES IT WORKED! getorderbyidcontroller 200 syccess");
          completedOrders = userINfo.value.data!.map((element) {
            print("list building");
            return element;
          }).toList();

          print(userINfo.value.message.toString() + "asdasd");
        } else if (userINfo.value.status == 100) {
          isLoading(false).obs;
          isListNull(true).obs;
          globals.showErrorSnackBar(userINfo.value.message!);
        } else {
          isLoading(false).obs;
          isListNull(true).obs;
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
  // fetchgetorderbyid() {
  //   isLoading(true).obs;
  //   isListNull(true).obs;
  //   var detail = get_orders_by_driver_idService.fetchGetOrdersByDriverId();
  //   if (detail != null) {
  //     print("detail is not null");
  //     try {
  //       orderINfo.value = detail;
  //
  //
  //       if (orderINfo.value.status == 200) {
  //         print("ORDER PLACED SUCCESSFULLLLLLLLY");
  //         isLoading(false).obs;
  //         isListNull(false).obs;
  //       } else if (orderINfo.value.status == 600) {
  //         isLoading(false).obs;
  //         isListNull(false).obs;
  //         globals.showErrorSnackBar("Not Subitted Data!");
  //       } else {
  //         isLoading(false).obs;
  //         isListNull(true).obs;
  //         globals.showErrorSnackBar("Not Subitted Data!");
  //       }
  //     } catch (e) {
  //       print(e);
  //       isLoading(false).obs;
  //       isListNull(false).obs;
  //       Get.snackbar(
  //         "Error",
  //         "Data is not getting!",
  //         icon: Icon(
  //           Icons.error_outline,
  //           color: Colors.white,
  //         ),
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //
  //       // TODO
  //     }
  //   } else {
  //     isLoading(false).obs;
  //     isListNull(false).obs;
  //     Get.snackbar(
  //       "Error",
  //       "User inactive",
  //       icon: Icon(
  //         Icons.error_outline,
  //         color: Colors.white,
  //       ),
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: Get.theme.primaryColor,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
}

//normal just kam karna that fetch order wali api hi just call karni, model, service class bni hui just main screen se and yahn is me setting karni.
