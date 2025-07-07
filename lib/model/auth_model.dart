import 'dart:convert';

class AuthModel {
  Data? data;
  String? auth;

  AuthModel({
    this.data,
    this.auth,
  });

  factory AuthModel.fromRawJson(String str) => AuthModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    auth: json["auth"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "auth": auth,
  };
}

class Data {
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
  bool? emailVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.state,
    this.campus,
    this.countryId,
    this.username,
    this.password,
    this.image,
    this.emailVerified,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    emailVerified:  json['emailVerified'],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
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
    "emailVerified": emailVerified,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
