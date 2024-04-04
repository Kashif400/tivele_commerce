import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Account {
  int? id;
  String? name;
  String? surname;
  String? userName;
  String? emailAddress;
  String? password;


  Account(
      {this.name,
        this.surname,
        this.userName,
        this.emailAddress,
        this.password});

  Account.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    userName = json['userName'];
    emailAddress = json['emailAddress'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['userName'] = this.userName;
    data['emailAddress'] = this.emailAddress;
    data['password'] = this.password;
    return data;
  }
}