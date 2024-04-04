// To parse this JSON data, do
//
//     final businessProfileEmptyProductM = businessProfileEmptyProductMFromJson(jsonString);

import 'dart:convert';

BusinessProfileEmptyProductM businessProfileEmptyProductMFromJson(String str) => BusinessProfileEmptyProductM.fromJson(json.decode(str));

String businessProfileEmptyProductMToJson(BusinessProfileEmptyProductM data) => json.encode(data.toJson());

class BusinessProfileEmptyProductM {
  BusinessProfileEmptyProductM({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  Data? data;
  String? message;
  String? token;

  factory BusinessProfileEmptyProductM.fromJson(Map<String, dynamic> json) => BusinessProfileEmptyProductM(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
    "message": message,
    "token": token,
  };
}

class Data {
  Data({
    this.products,
    this.name,
    this.description,
    this.businessImage,
    this.isReputable,
    this.followers,
    this.likes,
    this.gstAmount,
    this.tiveleFee,
    this.shippingCost
  });

  List<dynamic>? products;
  String? name;
  String? description;
  String? businessImage;
  String? isReputable;
  String? followers;
  String? likes;
  String? gstAmount;
  String? tiveleFee;
  String? shippingCost;
  factory Data.fromJson(Map<String, dynamic> json) => Data(
    products: List<dynamic>.from(json["products"].map((x) => x)),
    name: json["name"],
    description: json["description"],
    businessImage: json["business_image"],
    isReputable: json["isReputable"],
    followers: json["followers"],
    likes: json["likes"],
    gstAmount: json["gst_amount"],
    tiveleFee: json["tivele_fee"],
    shippingCost: json["shipping_cost"],
  );

  Map<String, dynamic> toJson() => {
    "products": List<dynamic>.from(products!.map((x) => x)),
    "name": name,
    "description": description,
    "business_image": businessImage,
    "isReputable": isReputable,
    "followers": followers,
    "likes": likes,
    "gst_amount": gstAmount,
    "tivele_fee": tiveleFee,
    "shipping_cost": shippingCost
  };
}
