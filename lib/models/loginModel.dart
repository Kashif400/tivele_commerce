// To parse this JSON data, do
//
//     final loginM = loginMFromJson(jsonString);

import 'dart:convert';

LoginM loginMFromJson(String str) => LoginM.fromJson(json.decode(str));

String loginMToJson(LoginM data) => json.encode(data.toJson());

class LoginM {
  LoginM({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  Data? data;
  String? message;
  String? token;

  factory LoginM.fromJson(Map<String, dynamic> json) => LoginM(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "message": message,
        "token": token,
      };
}

class Data {
  Data({
    this.userId,
    this.userType,
    this.userName,
    this.userEmail,
    this.userImage,
  });

  String? userId;
  String? userType;
  String? userName;
  String? userEmail;
  String? userImage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        userType: json["user_type"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userImage: json["user_image"]
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_type": userType,
        "user_name": userName,
        "user_email": userEmail,
        "user_image": userImage,
      };
}
