import 'package:e_commerce_foods/models/Order/orders.dart';
import 'package:e_commerce_foods/service/order/orders_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  List<OrdersItems> _order = [];
  List<OrdersItems> _myorder = [];
  OrdersItems? _orders;

  bool _productLoading = false;

  /// Get All getter & setter

  List<OrdersItems> get order => _order;

  set order(List<OrdersItems> data) {
    this._order = data;
    notifyListeners();
  }

  List<OrdersItems> get myorder => _myorder;

  set myorder(List<OrdersItems> data) {
    this._myorder = data;
    notifyListeners();
  }

  /// Get single getter & setter

  OrdersItems? get orders => _orders;

  set orders(OrdersItems? data) {
    this._orders = data;
    notifyListeners();
  }

  /// Get All Product function

  getOrder() async {
    try {
      var res = await OrdersService.getAll();
      order = [];
      var list = _order;

      for (var item in res["items"]) {
        var prod = OrdersItems.fromJson(item);
        list.add(prod);
      }
      order = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// Get Single Product function

  getOrders(String id) async {
    try {
      var prod = await OrdersService.get(id);
      var res = OrdersItems.fromJson(prod);
      orders = res;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// get OrderList by userId

  getOrderListByUserId() async {
    try {
      var userId = await SessionService.retrieveUser();
      var prod = await OrdersService.getOrderListByUserId(userId);
      myorder = [];
      var list = _myorder;
      for (var item in prod["items"]) {
        var prod = OrdersItems.fromJson(item);
        list.add(prod);
      }
      myorder = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  getMoreOrderListByUserId(skipCount) async {
    try {
      var userId = await SessionService.retrieveUser();
      var prod =
          await OrdersService.getMoreOrderListByUserId(userId, skipCount);

      var list = _myorder;
      for (var item in prod["items"]) {
        var prod = OrdersItems.fromJson(item);
        list.add(prod);
      }
      myorder = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }
}
