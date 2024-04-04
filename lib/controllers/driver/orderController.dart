import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/ordersModel.dart';
import 'package:e_commerce_foods/services/driver/orderService.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:location/location.dart' as Location;

class OrderController extends GetxController {
  Rx<OrderServiceModel> orderINfo = OrderServiceModel().obs;
  var isLoading = true.obs;
  var isListNull = true.obs;
  List<String> pickupLocation = [""].obs;
  List<String> dropoffLocation = [""].obs;
  List<String> distance = [""].obs;
  Location.LocationData? pos = null;
  Location.Location location = new Location.Location();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    iniate();
  }

  iniate() async {
    pos = await location.getLocation();
    Map userData = {
      'longitude': pos!.longitude.toString(),
      'latitude': pos!.latitude.toString(),
    };
    fetchAllOrders(userData);
  }

  pickUpAddress(double pickuplat, double pickuplong, double dropofflat,
      double dropofflong) async {
    // final pickupCoordinates = new Coordinates(pickuplat, pickuplong);
    // var pickupAddresses = await Geocoder.local.findAddressesFromCoordinates(pickupCoordinates);
    // var pickupFirst = pickupAddresses.first;
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(pickuplat, pickuplong);
    pickupLocation.add(globals.addressFromLatLng(placemarks));

    // final dropoffCoordinates = new Coordinates(dropofflat, dropofflong);
    // var dropoffAddresses = await Geocoder.local.findAddressesFromCoordinates(dropoffCoordinates);
    // var dropoffFirst = dropoffAddresses.first;
    List<geo.Placemark> placemarks2 =
        await geo.placemarkFromCoordinates(dropofflat, dropofflong);
    dropoffLocation.add(globals.addressFromLatLng(placemarks2));

    //distance.add(Global.calculateDistanceJustValue(pickuplat, pickuplong, dropofflat, dropofflong));
  }

  Future fetchAllOrders(Map<dynamic, dynamic> userData) async {
    pickupLocation.clear();
    dropoffLocation.clear();
    distance.clear();
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await orderService.fetchOrders(userData);
    if (detail != null) {
      try {
        orderINfo.value = detail;
        print(orderINfo.value.status.toString() + "my status");
        if (orderINfo.value.status == 200) {
          for (var val in orderINfo.value.data!) {
            await pickUpAddress(
                double.parse(val.productLatitude!),
                double.parse(val.productLongitude!),
                double.parse(val.userLatitude!),
                double.parse(val.userLongitude!));
          }
          isLoading(false).obs;
          isListNull(false).obs;
        } else if (orderINfo.value.status == 600) {
          isLoading(false).obs;
          isListNull(true).obs;
          globals.showErrorSnackBar("No Orders Found!");
        } else {
          isLoading(false).obs;
          isListNull(true).obs;
          globals.showErrorSnackBar("No Data Available!");
        }
      } catch (e) {
        print(e);
        isLoading(false).obs;
        isListNull(false).obs;
        // print(e.toString() + "errror");
        // Get.snackbar(
        //   "Error",
        //   "Data is not getting!",
        //   icon: Icon(
        //     Icons.error_outline,
        //     color: Colors.white,
        //   ),
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );

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
