import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/services/registrationService.dart';
import 'package:e_commerce_foods/views/business/businessLoginPage.dart';
import 'package:e_commerce_foods/views/customer/verificaionCodePage.dart';
import 'package:e_commerce_foods/views/driver/driverLoginPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  Rx<CheckApiResponseM> registerINfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  dynamic fetchRegistration(Map<String, Object?> userData, int checkApi) async {
    isLoading(true).obs;
    var detail = await RegistrationService.fetchRegister(userData);
    if (detail != null) {
      try {
        registerINfo.value = detail;
        if (registerINfo.value.status == 200) {
          isLoading(false).obs;
          //globals.showSuccesSnackBar(registerINfo.value.data);
          if (checkApi == 0) {
            print("Code");
            print(registerINfo.value.data);
            Get.offAll(VerificationCodePage(),
                arguments: [registerINfo.value.data, userData["email"]]);
          }
          if (checkApi == 1) {
            // globals.showSuccesSnackBar(registerINfo.value.data);
            Get.offAll(BusinessLoginPage());
          }
          if (checkApi == 2) {
            //  globals.showSuccesSnackBar(registerINfo.value.data);
            Get.offAll(DriverLoginPage());
          }
        } else if (registerINfo.value.status == 700) {
          isLoading(false).obs;
          globals.showErrorSnackBar(registerINfo.value.data!);
        } else {
          isLoading(false).obs;
          Get.snackbar(
            "Error Registration!",
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
          "Error Registration!",
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
        "Error Registration!",
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
