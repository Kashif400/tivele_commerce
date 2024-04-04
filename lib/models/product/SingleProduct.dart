import 'package:e_commerce_foods/models/FollowBusinessAccount/followBusiness.dart';
import 'package:e_commerce_foods/models/product/product_category.dart';
import 'package:e_commerce_foods/models/product/product_file.dart';

class SingleProductResult {
  SingleProduct? result;
  Null targetUrl;
  bool? success;
  Null error;
  bool? unAuthorizedRequest;
  bool? bAbp;

  SingleProductResult(
      {this.result,
      this.targetUrl,
      this.success,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  SingleProductResult.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new SingleProduct.fromJson(json['result'])
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

class SingleProduct {
  String? name;
  double? oldPrice;
  double? newPrice;
  String? description;
  double? gst;
  String? productCategoryId;
  ProductCategory? productCategory;
  ProductImage? productImage;
  String? productImageId;
  String? businessAccountId;
  BusinessAccount? businessAccount;
  int? productViewedCount;
  int? productRequestedCount;
  int? likeCount;
  double? ratingAverage;
  double? distance;
  List<ProductAttributes>? productAttributes;
  String? id;

  SingleProduct(
      {this.name,
      this.oldPrice,
      this.newPrice,
      this.description,
      this.gst,
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
      this.distance,
      this.productAttributes,
      this.id});

  SingleProduct.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    oldPrice = json['oldPrice'];
    newPrice = json['newPrice'];
    description = json['description'];
    gst = json['gst'];
    productCategoryId = json['productCategoryId'];
    productCategory = json['productCategory'] != null
        ? new ProductCategory.fromJson(json['productCategory'])
        : null;
    productImage = json['productImage'] != null
        ? ProductImage.fromJson(json['productImage'])
        : null;
    productImageId = json['productImageId'];
    businessAccountId = json['businessAccountId'];
    businessAccount = json['businessAccount'] != null
        ? new BusinessAccount.fromJson(json['businessAccount'])
        : null;
    productViewedCount = json['productViewedCount'];
    productRequestedCount = json['productRequestedCount'];
    likeCount = json['likeCount'];
    ratingAverage = json['ratingAverage'];
    distance = json['distance'];
    if (json['productAttributes'] != null) {
      productAttributes = <ProductAttributes>[];
      json['productAttributes'].forEach((v) {
        productAttributes!.add(new ProductAttributes.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['oldPrice'] = this.oldPrice;
    data['newPrice'] = this.newPrice;
    data['description'] = this.description;
    data['gst'] = this.gst;
    data['productCategoryId'] = this.productCategoryId;
    if (this.productCategory != null) {
      data['productCategory'] = this.productCategory!.toJson();
    }
    data['productImage'] = this.productImage;
    data['productImageId'] = this.productImageId;
    data['businessAccountId'] = this.businessAccountId;
    if (this.businessAccount != null) {
      data['businessAccount'] = this.businessAccount!.toJson();
    }
    data['productViewedCount'] = this.productViewedCount;
    data['productRequestedCount'] = this.productRequestedCount;
    data['likeCount'] = this.likeCount;
    data['ratingAverage'] = this.ratingAverage;
    data['distance'] = this.distance;
    if (this.productAttributes != null) {
      data['productAttributes'] =
          this.productAttributes!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class ProductAttributes {
  String? name;
  int? attributeType;
  List<ProductAttributeValues>? productAttributeValues;
  String? productId;
  String? id;

  ProductAttributes(
      {this.name,
      this.attributeType,
      this.productAttributeValues,
      this.productId,
      this.id});

  ProductAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    attributeType = json['attributeType'];
    if (json['productAttributeValues'] != null) {
      productAttributeValues = <ProductAttributeValues>[];
      json['productAttributeValues'].forEach((v) {
        productAttributeValues!.add(new ProductAttributeValues.fromJson(v));
      });
    }
    productId = json['productId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['attributeType'] = this.attributeType;
    if (this.productAttributeValues != null) {
      data['productAttributeValues'] =
          this.productAttributeValues!.map((v) => v.toJson()).toList();
    }
    data['productId'] = this.productId;
    data['id'] = this.id;
    return data;
  }
}

class ProductAttributeValues {
  String? name;
  String? productAttributeId;
  String? id;
  bool? isChecked = false;
  ProductAttributeValues({this.name, this.productAttributeId, this.id});

  ProductAttributeValues.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    productAttributeId = json['productAttributeId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['productAttributeId'] = this.productAttributeId;
    data['id'] = this.id;
    return data;
  }
}
