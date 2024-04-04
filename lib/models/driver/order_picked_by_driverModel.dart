// To parse this JSON data, do
//
//     final orderPickedByDriver = orderPickedByDriverFromJson(jsonString);

import 'dart:convert';

OrderPickedByDriver orderPickedByDriverFromJson(String str) =>
    OrderPickedByDriver.fromJson(json.decode(str));

String orderPickedByDriverToJson(OrderPickedByDriver data) =>
    json.encode(data.toJson());

class OrderPickedByDriver {
  OrderPickedByDriver({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  String? data;
  String? message;
  String? token;

  factory OrderPickedByDriver.fromJson(Map<String, dynamic> json) =>
      OrderPickedByDriver(
        status: json["status"],
        data: json["data"],
        message: json["message"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
        "message": message,
        "token": token,
      };
}
