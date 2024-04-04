import 'package:flutter/cupertino.dart';

class User with ChangeNotifier {
  int? userId;
  //BusinessUser businessUser;
  String? name;
  String? description;
  bool? isReputable;
  String? locationId;
  String? businessAccountImageId;
  //ProductImage businessAccountImage;
  //Location location;
  //int likeCount;
  //int followCount;
  //int productCount;
  String? id;

  User(
      {this.userId,
      //this.businessUser,
      this.name,
      this.description,
      this.isReputable,
      this.locationId,
      //this.location,
      this.businessAccountImageId,
      //this.businessAccountImage,
      //this.likeCount,
      //this.followCount,
      //this.productCount,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    //businessUser = BusinessUser.fromJson(json['businessUser']);
    name = json['name'];
    description = json['description'];
    isReputable = json['isReputable'];
    locationId = json['locationId'];
    businessAccountImageId = json['businessAccountImageId'];
    //businessAccountImage =  ProductImage.fromJson(json['businessAccountImage']);
    //ikeCount = json['likeCount'];
    //followCount = json['followCount'];
    //productCount = json['productCount'];
    //location = Location.fromJson(json['location']);
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    //data['businessUser'] = this.businessUser;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isReputable'] = this.isReputable;
    data['businessAccountImageId'] = this.businessAccountImageId;
    //data['businessAccountImage'] = this.businessAccountImage;
    data['locationId'] = this.locationId;
    //data['location'] = this.location;
    //data['likeCount'] = this.likeCount;
    //data['followCount'] = this.followCount;
    //data['productCount'] = this.productCount;
    data['id'] = this.id;
    return data;
  }
}
