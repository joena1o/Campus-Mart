import 'dart:convert';

class SuccessMessageModel {
  String? message;

  SuccessMessageModel({
    this.message,
  });

  factory SuccessMessageModel.fromRawJson(String str) => SuccessMessageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SuccessMessageModel.fromJson(Map<String, dynamic> json) => SuccessMessageModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
