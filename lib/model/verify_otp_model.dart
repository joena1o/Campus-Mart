import 'dart:convert';

class VerifyTokenModel {
  String? message;
  String? token;

  VerifyTokenModel({
    this.message,
    this.token,
  });

  factory VerifyTokenModel.fromRawJson(String str) => VerifyTokenModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyTokenModel.fromJson(Map<String, dynamic> json) => VerifyTokenModel(
    message: json["message"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
  };
}
