import 'package:flutter/cupertino.dart';
import 'package:e_commerce_foods/models/product/productBusinessAccount.dart';
import 'package:e_commerce_foods/models/product/product_file.dart';
import 'package:e_commerce_foods/models/product/product_category.dart';

class product {
  Result? result;
  Null targetUrl;
  bool? success;
  Null error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  product(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  product.fromJson(Map<String, dynamic> json) {
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
  List<Items>? items;

  Result({this.totalCount, this.items});

  Result.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
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

class Items with ChangeNotifier {
  String? name;
  double? oldPrice;
  double? newPrice;
  double? gst;
  String? description;
  String? productCategoryId;
  ProductCategory? productCategory;
  ProductImage? productImage;
  String? productImageId;
  String? businessAccountId;
  User? businessAccount;
  int? productViewedCount;
  int? productRequestedCount;
  int? likeCount;
  double? ratingAverage;
  String? id;

  Items(
      {this.name,
      this.oldPrice,
      this.newPrice,
      this.gst,
      this.description,
      this.productCategoryId,
      this.productCategory,
      this.productImage,
      this.productImageId,
      this.businessAccountId,
      this.businessAccount,
      this.productViewedCount,
      this.productRequestedCount,
      this.likeCount,
      this.ratingAverage,
      this.id});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    oldPrice = json['oldPrice'];
    newPrice = json['newPrice'];
    gst = json['gst'];
    description = json['description'];
    productCategoryId = json['productCategoryId'];
    productImageId = json['productImageId'];
    businessAccountId = json['businessAccountId'];
    businessAccount = json['businessAccount'] != null
        ? User.fromJson(json['businessAccount'])
        : null;
    productViewedCount = json['productViewedCount'];
    productRequestedCount = json['productRequestedCount'];
    likeCount = json['likeCount'];
    ratingAverage = json['ratingAverage'];
    id = json['id'];
    productCategory = json['productCategory'] != null
        ? ProductCategory.fromJson(json['productCategory'])
        : null;
    productImage = json['productImage'] != null
        ? ProductImage.fromJson(json['productImage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['oldPrice'] = this.oldPrice;
    data['newPrice'] = this.newPrice;
    data['gst'] = this.gst;
    data['description'] = this.description;
    data['productCategoryId'] = this.productCategoryId;
    data['productCategory'] = this.productCategory!.toJson();
    data['productImage'] = this.productImage!.toJson();
    data['productImageId'] = this.productImageId;
    data['businessAccountId'] = this.businessAccountId;
    data['businessAccount'] = this.businessAccount!.toJson();
    data['productViewedCount'] = this.productViewedCount;
    data['productRequestedCount'] = this.productRequestedCount;
    data['likeCount'] = this.likeCount;
    data['ratingAverage'] = this.ratingAverage;
    data['id'] = this.id;
    return data;
  }
}

class LikedItem with ChangeNotifier {
  int? userId;
  String? productId;
  String? id;

  LikedItem({this.userId, this.productId, this.id});

  LikedItem.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    productId = json['productId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['productId'] = this.productId;
    data['id'] = this.id;
    return data;
  }
}
