// To parse this JSON data, do
//
//     final getCategoriesM = getCategoriesMFromJson(jsonString);

import 'dart:convert';

GetCategoriesM getCategoriesMFromJson(String str) => GetCategoriesM.fromJson(json.decode(str));

String getCategoriesMToJson(GetCategoriesM data) => json.encode(data.toJson());

class GetCategoriesM {
  GetCategoriesM({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  List<Datum>? data;
  String? message;
  String? token;

  factory GetCategoriesM.fromJson(Map<String, dynamic> json) => GetCategoriesM(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
    "token": token,
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.description,
    this.image,
    this.status,
    this.dateAdded,
  });

  String? id;
  String? name;
  String? description;
  String? image;
  String? status;
  DateTime? dateAdded;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    status: json["status"],
    dateAdded: DateTime.parse(json["date_added"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "status": status,
    "date_added": dateAdded!.toIso8601String(),
  };
}
