import 'package:e_commerce_foods/models/Location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:e_commerce_foods/models/BusinessUser/businessUser.dart';
import 'package:e_commerce_foods/models/product/product_file.dart';

class Autogenerated {
  Result? result;
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
  List<User>? items;

  Result({this.totalCount, this.items});

  Result.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['items'] != null) {
      items = <User>[];
      json['items'].forEach((v) {
        items!.add(new User.fromJson(v));
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

class User with ChangeNotifier {
  int? userId;
  BusinessUser? businessUser;
  String? name;
  String? description;
  bool? isReputable;
  String? locationId;
  String? businessAccountImageId;
  ProductImage? businessAccountImage;
  Location? location;
  int? likeCount;
  int? followCount;
  int? productCount;
  String? id;

  User(
      {this.userId,
      this.businessUser,
      this.name,
      this.description,
      this.isReputable,
      this.locationId,
      this.location,
      this.businessAccountImageId,
      this.businessAccountImage,
      this.likeCount,
      this.followCount,
      this.productCount,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    businessUser = json['businessUser'] != null
        ? BusinessUser.fromJson(json['businessUser'])
        : null;
    name = json['name'];
    description = json['description'];
    isReputable = json['isReputable'];
    locationId = json['locationId'];
    businessAccountImageId = json['businessAccountImageId'];
    businessAccountImage = json['businessAccountImage'] != null
        ? ProductImage.fromJson(json['businessAccountImage'])
        : null;
    likeCount = json['likeCount'];
    followCount = json['followCount'];
    productCount = json['productCount'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['businessUser'] = this.businessUser;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isReputable'] = this.isReputable;
    data['businessAccountImageId'] = this.businessAccountImageId;
    data['businessAccountImage'] = this.businessAccountImage;
    data['locationId'] = this.locationId;
    data['location'] = this.location;
    data['likeCount'] = this.likeCount;
    data['followCount'] = this.followCount;
    data['productCount'] = this.productCount;
    data['id'] = this.id;
    return data;
  }
}
