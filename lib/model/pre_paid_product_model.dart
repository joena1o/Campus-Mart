import 'dart:convert';

import 'package:campus_mart/model/product_model.dart';


class PrePaidProductModel {
  String? message;
  ProductModel? product;

  PrePaidProductModel({
    this.message,
    this.product
  });

  factory PrePaidProductModel.fromRawJson(String str) => PrePaidProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrePaidProductModel.fromJson(Map<String, dynamic> json) => PrePaidProductModel(
    message: json["message"],
    product: ProductModel.fromJson(json['product'])
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "productId": product
  };
}
