import 'package:e_commerce_foods/models/BusinessUser/businessUser.dart';
import 'package:flutter/cupertino.dart';

import 'ProductOrders.dart';

class orders {
  Result? result;
  Null targetUrl;
  bool? success;
  Null error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  orders(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  orders.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    targetUrl = json['targetUrl'];
    success = json['success'];
    error = json['error'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
    bAbp = json['__abp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['targetUrl'] = this.targetUrl;
    data['success'] = this.success;
    data['error'] = this.error;
    data['unAuthorizedRequest'] = this.unAuthorizedRequest;
    data['__abp'] = this.bAbp;
    return data;
  }
}

class Result {
  int? totalCount;
  List<OrdersItems>? items;

  Result({this.totalCount, this.items});

  Result.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      items = <OrdersItems>[];
      json['items'].forEach((v) {
        items!.add(new OrdersItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrdersItems with ChangeNotifier {
  String? productId;
  Product? product;
  int? userId;
  BusinessUser? user;
  double? totalAmount;
  String? deliveryTime;
  String? latitude;
  String? longitude;
  int? referenceId;
  String? id;

  OrdersItems(
      {this.productId,
      this.product,
      this.userId,
      this.user,
      this.totalAmount,
      this.deliveryTime,
      this.longitude,
      this.latitude,
      this.referenceId,
      this.id});

  OrdersItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    product = Product.fromJson(json['product']);
    userId = json['userId'];
    user = BusinessUser.fromJson(json['user']);
    totalAmount = json['totalAmount'];
    deliveryTime = json['deliveryTime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    referenceId = json['referenceId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['product'] = this.product!.toJson();
    data['userId'] = this.userId;
    data['user'] = this.user!.toJson();
    data['totalAmount'] = this.totalAmount;
    data['deliveryTime'] = this.deliveryTime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['referenceId'] = this.referenceId;
    data['id'] = this.id;
    return data;
  }
}
