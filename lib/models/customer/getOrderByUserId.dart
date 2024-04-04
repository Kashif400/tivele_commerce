// To parse this JSON data, do
//
//     final getOrdersByUserIdService = getOrdersByUserIdServiceFromJson(jsonString);

import 'dart:convert';

GetOrdersByUserIdService getOrdersByUserIdServiceFromJson(String str) =>
    GetOrdersByUserIdService.fromJson(json.decode(str));

String getOrdersByUserIdServiceToJson(GetOrdersByUserIdService data) =>
    json.encode(data.toJson());

class GetOrdersByUserIdService {
  GetOrdersByUserIdService({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  List<Datum>? data;
  String? message;
  String? token;

  factory GetOrdersByUserIdService.fromJson(Map<String, dynamic> json) =>
      GetOrdersByUserIdService(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "token": token,
      };
}

class Datum {
  Datum({
    this.id,
    this.businessId,
    this.productId,
    this.userId,
    this.gst,
    this.tiveleFee,
    this.shippingCost,
    this.quantity,
    this.totalAmount,
    this.userLatitude,
    this.userLongitude,
    this.tip,
    this.driverId,
    this.status,
    this.deliveryImage,
    this.pickupImage,
    this.deliveryTime,
    this.pickupTime,
    this.orderTime,
    this.productLatitude,
    this.productLongitude,
    this.productName,
    this.timeAgo,
    this.reviewOrder
  });

  String? id;
  String? businessId;
  String? productId;
  String? userId;
  String? gst;
  String? tiveleFee;
  String? shippingCost;
  String? quantity;
  String? totalAmount;
  String? userLatitude;
  String? userLongitude;
  String? tip;
  String? driverId;
  String? status;
  String? deliveryImage;
  String? pickupImage;
  DateTime? deliveryTime;
  DateTime? pickupTime;
  DateTime? orderTime;
  String? productLatitude;
  String? productLongitude;
  String? productName;
  String? timeAgo;
  bool? reviewOrder;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        businessId: json["business_id"],
        productId: json["product_id"],
        userId: json["user_id"],
        gst: json["gst"],
        tiveleFee: json["tivele_fee"],
        shippingCost: json["shipping_cost"],
        quantity: json["quantity"],
        totalAmount: json["total_amount"],
        userLatitude: json["user_latitude"],
        userLongitude: json["user_longitude"],
        tip: json["tip"],
        driverId: json["driver_id"],
        status: json["status"],
        deliveryImage: json["delivery_image"],
        pickupImage: json["pickup_image"],
        deliveryTime: DateTime.parse(json["delivery_time"]),
        pickupTime: DateTime.parse(json["pickup_time"]),
        orderTime: DateTime.parse(json["order_time"]),
        productLatitude: json["product_latitude"],
        productLongitude: json["product_longitude"],
        productName: json["product_name"],
        timeAgo: json["time_ago"],
        reviewOrder: json["review_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "product_id": productId,
        "user_id": userId,
        "gst": gst,
        "tivele_fee": tiveleFee,
        "shipping_cost": shippingCost,
        "quantity": quantity,
        "total_amount": totalAmount,
        "user_latitude": userLatitude,
        "user_longitude": userLongitude,
        "tip": tip,
        "driver_id": driverId,
        "status": status,
        "delivery_image": deliveryImage,
        "pickup_image": pickupImage,
        "delivery_time": deliveryTime!.toIso8601String(),
        "pickup_time": pickupTime!.toIso8601String(),
        "order_time": orderTime!.toIso8601String(),
        "product_latitude": productLatitude,
        "product_longitude": productLongitude,
        "product_name": productName,
        "time_ago": timeAgo,
        "review_order": reviewOrder,
      };
}
