import 'package:flutter/cupertino.dart';

class Autogenerated {
  DriverAccount? result;
  Null targetUrl;
  bool? success;
  Null error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  Autogenerated(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new DriverAccount.fromJson(json['result'])
        : null;
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

class DriverAccount with ChangeNotifier {
  int? userId;
  String? driverName;
  String? profileImage;
  String? driverId;
  String? address;
  String? city;
  String? provience;
  int? status;
  String? drivingLicenceId;
  List<Orders>? orders;
  String? id;

  DriverAccount(
      {this.userId,
      this.driverName,
      this.profileImage,
      this.driverId,
      this.address,
      this.city,
      this.provience,
      this.status,
      this.drivingLicenceId,
      this.orders,
      this.id});

  DriverAccount.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    driverName = json['driverName'];
    profileImage = json['profileImage'];
    driverId = json['driverId'];
    address = json['address'];
    city = json['city'];
    provience = json['provience'];
    status = json['status'];
    drivingLicenceId = json['drivingLicenceId'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['driverName'] = this.driverName;
    data['profileImage'] = this.profileImage;
    data['driverId'] = this.driverId;
    data['address'] = this.address;
    data['city'] = this.city;
    data['provience'] = this.provience;
    data['status'] = this.status;
    data['drivingLicenceId'] = this.drivingLicenceId;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Orders {
  String? productId;
  String? productName;
  DateTime? deliveryTime;
  String? id;

  Orders({this.productId, this.productName, this.deliveryTime, this.id});

  Orders.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    deliveryTime = DateTime.parse(json['deliveryTime']);
    //deliveryTime.toLocal();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['deliveryTime'] = this.deliveryTime;
    data['id'] = this.id;
    return data;
  }
}
