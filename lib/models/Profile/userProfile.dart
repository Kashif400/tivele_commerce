import 'package:flutter/cupertino.dart';
import 'package:e_commerce_foods/models/product/product_file.dart';

class Autogenerated {
  UserProfile? result;
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
    result = json['result'] != null
        ? new UserProfile.fromJson(json['result'])
        : null;
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

class UserProfile with ChangeNotifier {
  String? emailAddress;
  String? userName;
  String? name;
  String? userProfileId;
  ProductImage? userProfile;
  int? id;

  UserProfile(
      {this.emailAddress,
      this.userName,
      this.name,
      this.userProfileId,
      this.userProfile,
      this.id});

  UserProfile.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    userName = json['userName'];
    name = json['name'];
    userProfileId = json['userProfileId'];
    userProfile = json['userProfile'] != null
        ? new ProductImage.fromJson(json['userProfile'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailAddress'] = this.emailAddress;
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['userProfileId'] = this.userProfileId;
    if (this.userProfile != null) {
      data['userProfile'] = this.userProfile!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}
