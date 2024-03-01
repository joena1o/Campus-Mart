import 'dart:convert';

class AdAlertModel {
  String? id;
  String? userId;
  String? category;
  String? item;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  AdAlertModel({
    this.id,
    this.userId,
    this.category,
    this.item,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AdAlertModel.fromRawJson(String str) => AdAlertModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdAlertModel.fromJson(Map<String, dynamic> json) => AdAlertModel(
    id: json["_id"],
    userId: json["userId"],
    category: json["category"],
    item: json["item"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "category": category,
    "item": item,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
