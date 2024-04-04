// To parse this JSON data, do
//
//     final getFavoriteProductsModel = getFavoriteProductsModelFromJson(jsonString);

import 'dart:convert';

GetFavoriteProductsModel getFavoriteProductsModelFromJson(String str) =>
    GetFavoriteProductsModel.fromJson(json.decode(str));

String getFavoriteProductsModelToJson(GetFavoriteProductsModel data) =>
    json.encode(data.toJson());

class GetFavoriteProductsModel {
  GetFavoriteProductsModel({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  List<Datum>? data;
  String? message;
  String? token;

  factory GetFavoriteProductsModel.fromJson(Map<String, dynamic> json) =>
      GetFavoriteProductsModel(
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
    this.productCategoryId,
    this.name,
    this.description,
    this.oldPrice,
    this.newPrice,
    this.gst,
    this.productImages,
    this.longitude,
    this.latitude,
    this.status,
    this.dateAdded,
    this.likeId,
    this.gstAmount,
    this.tiveleFee,
    this.shippingCost,
    this.likes,
    this.categoryName,
    this.isLiked,
    this.businessImage,
    this.businessName,
    this.isReputable,
    this.rating,
    this.timeAgo,
  });

  String? id;
  String? businessId;
  String? productCategoryId;
  String? name;
  String? description;
  String? oldPrice;
  String? newPrice;
  String? gst;
  String? productImages;
  String? longitude;
  String? latitude;
  String? status;
  DateTime? dateAdded;
  String? likeId;
  String? gstAmount;
  String? tiveleFee;
  String? shippingCost;
  int? likes;
  String? categoryName;
  bool? isLiked;
  String? businessImage;
  String? businessName;
  String? isReputable;
  String? rating;
  String? timeAgo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        businessId: json["business_id"],
        productCategoryId: json["product_category_id"],
        name: json["name"],
        description: json["description"],
        oldPrice: json["old_price"],
        newPrice: json["new_price"],
        gst: json["gst"],
        productImages: json["product_images"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        status: json["status"],
        dateAdded: DateTime.parse(json["date_added"]),
        likeId: json["like_id"],
        gstAmount: json["gst_amount"],
        tiveleFee: json["tivele_fee"],
        shippingCost: json["shipping_cost"],
        likes: json["likes"],
        categoryName: json["category_name"],
        isLiked: json["isLiked"],
        businessImage: json["business_image"],
        businessName: json["business_name"],
        isReputable: json["isReputable"],
        rating: json["rating"],
        timeAgo: json["time_ago"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "product_category_id": productCategoryId,
        "name": name,
        "description": description,
        "old_price": oldPrice,
        "new_price": newPrice,
        "gst": gst,
        "product_images": productImages,
        "longitude": longitude,
        "latitude": latitude,
        "status": status,
        "date_added": dateAdded!.toIso8601String(),
        "like_id": likeId,
        "gst_amount": gstAmount,
        "tivele_fee": tiveleFee,
        "shipping_cost": shippingCost,
        "likes": likes,
        "category_name": categoryName,
        "isLiked": isLiked,
        "business_image": businessImage,
        "business_name": businessName,
        "isReputable": isReputable,
        "rating": rating,
        "time_ago": timeAgo,
      };
}
