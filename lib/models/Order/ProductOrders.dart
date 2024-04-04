import 'package:flutter/cupertino.dart';
import 'package:e_commerce_foods/models/User/user.dart';
import 'package:e_commerce_foods/models/product/product_file.dart';

class Product with ChangeNotifier {
  String? name;
  double? price;
  String? description;
  String? productCategoryId;
  //Null productCategory;
  ProductImage? productImage;
  String? productImageId;
  String? businessAccountId;
  User? businessAccount;
  int? productViewedCount;
  int? userId;
  int? productRequestedCount;
  //Null likeCount;
  double? ratingAverage;
  String? id;

  Product(
      {this.name,
      this.price,
      this.description,
      this.productCategoryId,
      //this.productCategory,
      this.productImage,
      this.productImageId,
      this.userId,
      this.businessAccountId,
      this.businessAccount,
      this.productViewedCount,
      this.productRequestedCount,
      //this.likeCount,
      //this.ratingAverage,
      this.id});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    description = json['description'];
    productCategoryId = json['productCategoryId'];
    //productCategory = json['productCategory'];
    productImage = json["productImage"] != null
        ? ProductImage.fromJson(json['productImage'])
        : null;
    productImageId = json['productImageId'];
    userId = json['userId'];
    businessAccountId = json['businessAccountId'];
    businessAccount = json['businessAccount'] != null
        ? User.fromJson(json['businessAccount'])
        : null;
    productViewedCount = json['productViewedCount'];
    productRequestedCount = json['productRequestedCount'];
    //likeCount = json['likeCount'];
    ratingAverage = json['ratingAverage'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['description'] = this.description;
    data['productCategoryId'] = this.productCategoryId;
    data['userId'] = this.userId;
    //data['productCategory'] = this.productCategory;
    data['productImage'] = this.productImage!.toJson();
    data['productImageId'] = this.productImageId;
    data['businessAccountId'] = this.businessAccountId;
    data['businessAccount'] = this.businessAccount!.toJson();
    data['productViewedCount'] = this.productViewedCount;
    data['productRequestedCount'] = this.productRequestedCount;
    //data['likeCount'] = this.likeCount;
    data['ratingAverage'] = this.ratingAverage;
    data['id'] = this.id;
    return data;
  }
}
