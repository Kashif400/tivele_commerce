// To parse this JSON data, do
//
//     final getExploreDataM = getExploreDataMFromJson(jsonString);

import 'dart:convert';

GetExploreDataM getExploreDataMFromJson(String str) => GetExploreDataM.fromJson(json.decode(str));

String getExploreDataMToJson(GetExploreDataM data) => json.encode(data.toJson());

class GetExploreDataM {
  GetExploreDataM({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  List<ProductDatum>? data;
  String? message;
  String? token;

  factory GetExploreDataM.fromJson(Map<String, dynamic> json) => GetExploreDataM(
    status: json["status"],
    data: List<ProductDatum>.from(json["data"].map((x) => ProductDatum.fromJson(x))),
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

class ProductDatum {
  ProductDatum({
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
    this.productAttributes,
    this.status,
    this.dateAdded,
    this.distance,
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
  String? distance;
  String? gstAmount;
  String? tiveleFee;
  String? shippingCost;
  int? likes;
  List<ProductAttribute>? productAttributes;
  String? categoryName;
  bool? isLiked;
  String? businessImage;
  String? businessName;
  String? isReputable;
  String? rating;
  String? timeAgo;

  factory ProductDatum.fromJson(Map<String, dynamic> json) => ProductDatum(
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
    productAttributes: List<ProductAttribute>.from(json["product_attributes"].map((x) => ProductAttribute.fromJson(x))),
    status: json["status"],
    dateAdded: DateTime.parse(json["date_added"]),
    distance: json["distance"],
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
    "product_attributes": List<dynamic>.from(productAttributes!.map((x) => x.toJson())),
    "status": status,
    "date_added": dateAdded!.toIso8601String(),
    "distance": distance,
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
class ProductAttribute {
  ProductAttribute({
    this.attributeName,
    this.attributeValues,
  });

  String? attributeName;
  List<AttributeValue>? attributeValues;

  factory ProductAttribute.fromJson(Map<String, dynamic> json) => ProductAttribute(
    attributeName: json["attribute_name"],
    attributeValues: List<AttributeValue>.from(json["attribute_values"].map((x) => AttributeValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "attribute_name": attributeName,
    "attribute_values": List<dynamic>.from(attributeValues!.map((x) => x.toJson())),
  };
}

class AttributeValue {
  AttributeValue({
    this.id,
    this.productAttributeId,
    this.productAttributeOption,
    this.status,
    this.dateAdded,
  });

  String? id;
  String? productAttributeId;
  String? productAttributeOption;
  String? status;
  DateTime? dateAdded;

  factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
    id: json["id"],
    productAttributeId: json["product_attribute_id"],
    productAttributeOption: json["product_attribute_option"],
    status: json["status"],
    dateAdded: DateTime.parse(json["date_added"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_attribute_id": productAttributeId,
    "product_attribute_option": productAttributeOption,
    "status": status,
    "date_added": dateAdded!.toIso8601String(),
  };
}