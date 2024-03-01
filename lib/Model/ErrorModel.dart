import 'dart:convert';

class ErrorModel {
  String? message;

  ErrorModel({
    this.message,
  });

  factory ErrorModel.fromRawJson(String str) => ErrorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
