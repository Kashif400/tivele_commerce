import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Location with ChangeNotifier {
  String? address1;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? latitude;
  String? longitude;
  String? id;

  Location(
      {this.address1,
        this.city,
        this.state,
        this.country,
        this.postalCode,
        this.latitude,
        this.longitude,
        this.id});

  Location.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postalCode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postalCode'] = this.postalCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['id'] = this.id;
    return data;
  }
}