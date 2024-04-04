import 'package:flutter/cupertino.dart';

class SingleOrder with ChangeNotifier {
  String? productId;
  String? userId;
  double? gst;
  double? shippingCost;
  double? tiveleFee;
  double? totalAmount;
  int? quantity;
  List<OrderProductAttributes>? orderProductAttributes;
  String? latitude;
  String? longitude;

  SingleOrder(
      {this.productId,
      this.userId,
      this.gst,
      this.shippingCost,
      this.tiveleFee,
      this.totalAmount,
      this.quantity,
      this.orderProductAttributes,
      this.latitude,
      this.longitude});

  SingleOrder.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    userId = json['userId'];
    gst = json['gst'];
    shippingCost = json['shippingCost'];
    tiveleFee = json['tiveleFee'];
    totalAmount = json['totalAmount'];
    quantity = json['quantity'];
    if (json['orderProductAttributes'] != null) {
      orderProductAttributes = <OrderProductAttributes>[];
      json['orderProductAttributes'].forEach((v) {
        orderProductAttributes!.add(new OrderProductAttributes.fromJson(v));
      });
    }
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['userId'] = this.userId;
    data['gst'] = this.gst;
    data['shippingCost'] = this.shippingCost;
    data['tiveleFee'] = this.tiveleFee;
    data['totalAmount'] = this.totalAmount;
    data['quantity'] = this.quantity;
    if (this.orderProductAttributes != null) {
      data['orderProductAttributes'] =
          this.orderProductAttributes!.map((v) => v.toJson()).toList();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class OrderProductAttributes {
  String? productAttributeId;
  String? productAttributeValueId;

  OrderProductAttributes(
      {this.productAttributeId, this.productAttributeValueId});

  OrderProductAttributes.fromJson(Map<String, dynamic> json) {
    productAttributeId = json['productAttributeId'];
    productAttributeValueId = json['productAttributeValueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productAttributeId'] = this.productAttributeId;
    data['productAttributeValueId'] = this.productAttributeValueId;
    return data;
  }
}
