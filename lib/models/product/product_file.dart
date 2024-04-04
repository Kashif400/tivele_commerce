
import 'package:flutter/cupertino.dart';

class ProductImage with ChangeNotifier {
  String? contentType;
  int? length;
  String? name;
  String? fileName;
  String? fileKey;
  String? url;
  String? id;

  ProductImage(
      {this.contentType,
        this.length,
        this.name,
        this.fileName,
        this.fileKey,
        this.url,
        this.id});

  ProductImage.fromJson(Map<String, dynamic> json) {
    contentType = json['contentType'];
    length = json['length'];
    name = json['name'];
    fileName = json['fileName'];
    fileKey = json['fileKey'];
    url = json['url'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contentType'] = this.contentType;
    data['length'] = this.length;
    data['name'] = this.name;
    data['fileName'] = this.fileName;
    data['fileKey'] = this.fileKey;
    data['url'] = this.url;
    data['id'] = this.id;
    return data;
  }
}