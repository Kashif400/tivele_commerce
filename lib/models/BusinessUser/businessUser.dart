import 'package:flutter/cupertino.dart';
import 'package:e_commerce_foods/models/product/product_file.dart';

class BusinessUser with ChangeNotifier {
  String? userName;
  String? name;
  String? surname;
  String? emailAddress;
  bool? isActive;
  String? fullName;
  //Null lastLoginTime;
  String? creationTime;
  String? userProfileId;
  ProductImage? userProfile;
  //Null roleNames;
  int? id;

  BusinessUser(
      {this.userName,
      this.name,
      this.surname,
      this.emailAddress,
      this.isActive,
      this.fullName,
      this.userProfileId,
      this.userProfile,
      //this.lastLoginTime,
      this.creationTime,

      //this.roleNames,
      this.id});

  BusinessUser.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    name = json['name'];
    surname = json['surname'];
    emailAddress = json['emailAddress'];
    isActive = json['isActive'];
    fullName = json['fullName'];
    userProfileId = json['userProfiledId'];
    userProfile = json['userProfile'] != null
        ? new ProductImage.fromJson(json['userProfile'])
        : null;
    id = json['id'];
    //lastLoginTime = json['lastLoginTime'];
    creationTime = json['creationTime'];
    //roleNames = json['roleNames'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['emailAddress'] = this.emailAddress;
    data['isActive'] = this.isActive;
    data['fullName'] = this.fullName;
    data['userProfileId'] = this.userProfileId;
    if (this.userProfile != null) {
      data['userProfile'] = this.userProfile!.toJson();
    }
    //data['lastLoginTime'] = this.lastLoginTime;
    data['creationTime'] = this.creationTime;
    //data['roleNames'] = this.roleNames;
    data['id'] = this.id;
    return data;
  }
}
