// To parse this JSON data, do
//
//     final businessProfileM = businessProfileMFromJson(jsonString);

import 'dart:convert';

BusinessProfileM businessProfileMFromJson(String str) => BusinessProfileM.fromJson(json.decode(str));

String businessProfileMToJson(BusinessProfileM data) => json.encode(data.toJson());

class BusinessProfileM {
  BusinessProfileM({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  Data? data;
  String? message;
  String? token;

  factory BusinessProfileM.fromJson(Map<String, dynamic> json) => BusinessProfileM(
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
    this.shippingCost,
  });

  List<Product>? products;
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
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
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
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    "name": name,
    "description": description,
    "business_image": businessImage,
    "isReputable": isReputable,
    "followers": followers,
    "likes": likes,
    "gst_amount": gstAmount,
    "tivele_fee": tiveleFee,
    "shipping_cost": shippingCost,
  };
}

class Product {
  Product({
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
    this.categoryName,
    this.likes,
    this.rating,
    this.productAttributes,
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
  String? categoryName;
  String? likes;
  dynamic rating;
  List<ProductAttribute>? productAttributes;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
    categoryName: json["category_name"],
    likes: json["likes"],
    rating: json["rating"],
    productAttributes: List<ProductAttribute>.from(json["product_attributes"].map((x) => ProductAttribute.fromJson(x))),
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
    "category_name": categoryName,
    "likes": likes,
    "rating": rating,
    "product_attributes": List<dynamic>.from(productAttributes!.map((x) => x.toJson())),
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
