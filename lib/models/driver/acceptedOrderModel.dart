// To parse this JSON data, do
//
//     final acceptedOrder = acceptedOrderFromJson(jsonString);

import 'dart:convert';

AcceptedOrder acceptedOrderFromJson(String str) =>
    AcceptedOrder.fromJson(json.decode(str));

String acceptedOrderToJson(AcceptedOrder data) => json.encode(data.toJson());

class AcceptedOrder {
  AcceptedOrder({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  String? data;
  String? message;
  String? token;

  factory AcceptedOrder.fromJson(Map<String, dynamic> json) => AcceptedOrder(
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
