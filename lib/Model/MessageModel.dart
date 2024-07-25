// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  String? id;
  String? userId;
  String? receiverId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? convertedMessageId;
  String? convertedUserId;
  String? convertedReceiverId;
  List<Chat>? chats;
  List<User>? user;
  List<User>? user2;

  MessageModel({
    required this.id,
    required this.userId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.convertedMessageId,
    required this.convertedUserId,
    required this.convertedReceiverId,
    required this.chats,
    required this.user,
    required this.user2,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json["_id"],
    userId: json["userId"],
    receiverId: json["receiverId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    convertedMessageId: json["convertedMessageId"],
    convertedUserId: json["convertedUserId"],
    convertedReceiverId: json["convertedReceiverId"],
    chats: List<Chat>.from(json["chats"].map((x) => Chat.fromJson(x))),
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    user2: List<User>.from(json["user2"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "receiverId": receiverId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "convertedMessageId": convertedMessageId,
    "convertedUserId": convertedUserId,
    "convertedReceiverId": convertedReceiverId,
    "chats": List<dynamic>.from(chats!.map((x) => x.toJson())),
    "user": List<dynamic>.from(user!.map((x) => x.toJson())),
    "user2": List<dynamic>.from(user2!.map((x) => x.toJson())),
  };
}

class Chat {
  String id;
  String userId;
  String receiverId;
  String chatId;
  String type;
  bool seen;
  String message;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Chat({
    required this.id,
    required this.userId,
    required this.receiverId,
    required this.chatId,
    required this.type,
    required this.seen,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["_id"],
    userId: json["userId"],
    receiverId: json["receiverId"],
    chatId: json["chatId"],
    seen: json['seen'],
    type: json["type"],
    message: json["message"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "receiverId": receiverId,
    "chatId": chatId,
    "type": type,
    "seen": seen,
    "message": message,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? state;
  String? campus;
  String? countryId;
  String? username;
  String? password;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  bool? emailVerified;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.state,
    required this.campus,
    required this.countryId,
    required this.username,
    required this.password,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.emailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phone: json["phone"],
    state: json["state"],
    campus: json["campus"],
    countryId: json["countryId"],
    username: json["username"],
    password: json["password"],
    image: json["image"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    emailVerified: json["emailVerified"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phone": phone,
    "state": state,
    "campus": campus,
    "countryId": countryId,
    "username": username,
    "password": password,
    "image": image,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "emailVerified": emailVerified,
  };
}
