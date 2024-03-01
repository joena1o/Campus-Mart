import 'dart:convert';

class NotificationModel {
  String? id;
  String? title;
  String? description;
  String? notificationType;
  String? productId;
  String? userId;
  bool? read;
  DateTime? createdAt;
  DateTime? updatedAt;
  // int? v;

  NotificationModel({
    this.id,
    this.title,
    this.description,
    this.notificationType,
    this.productId,
    this.userId,
    this.read,
    this.createdAt,
    this.updatedAt,
    // this.v,
  });

  factory NotificationModel.fromRawJson(String str) => NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    notificationType: json["notificationType"],
    productId: json["productId"],
    userId: json["userId"],
    read: json["read"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    // v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "notificationType": notificationType,
    "productId": productId,
    "userId": userId,
    "read": read,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    // "__v": v,
  };
}
