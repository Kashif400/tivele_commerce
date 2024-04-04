// To parse this JSON data, do
//
//     final checkApiResponseM = checkApiResponseMFromJson(jsonString);

import 'dart:convert';

CheckApiResponseM checkApiResponseMFromJson(String str) => CheckApiResponseM.fromJson(json.decode(str));

String checkApiResponseMToJson(CheckApiResponseM data) => json.encode(data.toJson());

class CheckApiResponseM {
  CheckApiResponseM({
    this.status,
    this.data,
    this.message,
    this.token,
  });

  int? status;
  String? data;
  String? message;
  String? token;

  factory CheckApiResponseM.fromJson(Map<String, dynamic> json) => CheckApiResponseM(
    status: json["status"],
    data: json["data"],
    message: json["message"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
    "message": message,
    "token": token,
  };
}
