// To parse this JSON data, do
//
//     final getOrdersByDriverIdModel = getOrdersByDriverIdModelFromJson(jsonString);

import 'dart:convert';

GetOrdersByDriverIdModel getOrdersByDriverIdModelFromJson(String str) =>
    GetOrdersByDriverIdModel.fromJson(json.decode(str));

String getOrdersByDriverIdModelToJson(GetOrdersByDriverIdModel data) =>
    json.encode(data.toJson());

class GetOrdersByDriverIdModel {
  GetOrdersByDriverIdModel({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  List<Datum>? data;
  String? message;
  String? token;

  factory GetOrdersByDriverIdModel.fromJson(Map<String, dynamic> json) =>
      GetOrdersByDriverIdModel(
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
  });

  String? id;
  BusinessId? businessId;
  String? productId;
  UserId? userId;
  String? gst;
  String? tiveleFee;
  String? shippingCost;
  String? quantity;
  String? totalAmount;
  String? userLatitude;
  String? userLongitude;
  String? tip;
  DriverId? driverId;
  Status? status;
  String? deliveryImage;
  String? pickupImage;
  DateTime? deliveryTime;
  dynamic pickupTime;
  DateTime? orderTime;
  String? productLatitude;
  String? productLongitude;
  ProductName? productName;
  String? timeAgo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        businessId: businessIdValues.map[json["business_id"]],
        productId: json["product_id"],
        userId: userIdValues.map[json["user_id"]],
        gst: json["gst"],
        tiveleFee: json["tivele_fee"],
        shippingCost: json["shipping_cost"],
        quantity: json["quantity"],
        totalAmount: json["total_amount"],
        userLatitude: json["user_latitude"],
        userLongitude: json["user_longitude"],
        tip: json["tip"],
        driverId: driverIdValues.map[json["driver_id"]],
        status: statusValues.map[json["status"]],
        deliveryImage: json["delivery_image"],
        pickupImage: json["pickup_image"],
        deliveryTime: DateTime.parse(json["delivery_time"]),
        pickupTime: json["pickup_time"],
        orderTime: DateTime.parse(json["order_time"]),
        productLatitude: json["product_latitude"],
        productLongitude: json["product_longitude"],
        productName: productNameValues.map[json["product_name"]],
        timeAgo: json["time_ago"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessIdValues.reverse![businessId!],
        "product_id": productId,
        "user_id": userIdValues.reverse![userId!],
        "gst": gst,
        "tivele_fee": tiveleFee,
        "shipping_cost": shippingCost,
        "quantity": quantity,
        "total_amount": totalAmount,
        "user_latitude": userLatitude,
        "user_longitude": userLongitude,
        "tip": tip,
        "driver_id": driverIdValues.reverse![driverId!],
        "status": statusValues.reverse![status!],
        "delivery_image": deliveryImage,
        "pickup_image": pickupImage,
        "delivery_time": deliveryTime!.toIso8601String(),
        "pickup_time": pickupTime,
        "order_time": orderTime!.toIso8601String(),
        "product_latitude": productLatitude,
        "product_longitude": productLongitude,
        "product_name": productNameValues.reverse![productName!],
        "time_ago": timeAgo,
      };
}

enum BusinessId { B16294434892 }

final businessIdValues = EnumValues({"B16294434892": BusinessId.B16294434892});

enum DriverId { D16294434311 }

final driverIdValues = EnumValues({"D16294434311": DriverId.D16294434311});

enum PickupTimeEnum { THE_00000000000000 }

final pickupTimeEnumValues =
    EnumValues({"0000-00-00 00:00:00": PickupTimeEnum.THE_00000000000000});

enum ProductName { MY_PHOTO, DOUBLE_VIDEO, EARTH_VIDOE }

final productNameValues = EnumValues({
  "double video": ProductName.DOUBLE_VIDEO,
  "Earth vidoe": ProductName.EARTH_VIDOE,
  "my photo": ProductName.MY_PHOTO
});

enum Status { ACCEPTED, PICKED, DELIVERED }

final statusValues = EnumValues({
  "Accepted": Status.ACCEPTED,
  "Delivered": Status.DELIVERED,
  "Picked": Status.PICKED
});

enum UserId { U16294433740 }

final userIdValues = EnumValues({"U16294433740": UserId.U16294433740});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
