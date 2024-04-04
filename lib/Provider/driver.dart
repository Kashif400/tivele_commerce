import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/models/DriverAccount/driver_account.dart';
import 'package:e_commerce_foods/models/Order/orders.dart';
import 'package:e_commerce_foods/service/DriverAccount/driverAccount.dart';
import 'package:e_commerce_foods/service/order/orders_service.dart';

class DriversProvider with ChangeNotifier {
  List<DriverAccount> _driver = [];
  //List<DriverAccount> _productlikebyUser = [];
  DriverAccount? _drivers;
  List<OrdersItems> _driverOrder = [];
  List<String> _placemarks = [];
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool data) {
    this._loading = data;
    //notifyListeners();
  }

  List<DriverAccount> get driver => _driver;

  set driver(List<DriverAccount> data) {
    this._driver = data;
    notifyListeners();
  }

  DriverAccount? get drivers => _drivers;

  set drivers(DriverAccount? data) {
    this._drivers = data;
    notifyListeners();
  }

  List<String> get Placemarks => _placemarks;
  set Placemarks(List<String> data) {
    this._placemarks = data;
    notifyListeners();
  }

  List<OrdersItems> get DriverOrders => _driverOrder;

  set DriverOrders(List<OrdersItems> data) {
    this._driverOrder = data;
    notifyListeners();
  }

  /// Get All Product function

  getDriver() async {
    try {
      var res = await DriverAccountService.getAll();
      driver = [];
      var list = _driver;

      for (var item in res["items"]) {
        var prod = DriverAccount.fromJson(item);
        list.add(prod);
      }
      driver = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  getDriverOrders() async {
    try {
      loading = true;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var orders = await OrdersService.getAllDriversOrders(
          Longitude: position.longitude, Latitude: position.latitude);
      if (orders != null) {
        _driverOrder = [];
        var list = _driverOrder;
        print(orders.toString() + " this is ");
        for (var item in orders["items"]) {
          var res = OrdersItems.fromJson(item);
          list.add(res);
          List<Placemark> placemarks = await placemarkFromCoordinates(
              double.parse(res.latitude!), double.parse(res.longitude!));
          if (placemarks.length > 0) {
            var location = placemarks[0];
            Placemarks.add(": " +
                location.name! +
                ", " +
                location.thoroughfare! +
                ", " +
                location.subLocality! +
                ", " +
                location.locality!);
          }
        }

        DriverOrders = list;
      }
    } catch (err) {
      print(err);
    }
    loading = false;
  }

  /// Get Single Product function
  getCurrentDrivers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? accountid = await prefs.getString("user_id");
      print(accountid.toString() + "driver user_id");
      var status = 3;
      var prod = await DriverAccountService.get(accountid);
      // final requestbody = json.decode(prod.body);
      // var data=requestbody["result"];
      var res = DriverAccount.fromJson(prod);
      drivers = res;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }
  // getCurrentDrivers() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String accountid= await prefs.getString("DriverAccountID");
  //     var status=3;
  //     var prod = await OrdersService.getAllCompletedOrders(accountid,status);
  //     // final requestbody = json.decode(prod.body);
  //     // var data=requestbody["result"];
  //     var res= DriverAccount.fromJson(prod);
  //     drivers=res;
  //   }
  //   catch (err) {
  //     print(err);
  //   }
  //   notifyListeners();
  // }
}
