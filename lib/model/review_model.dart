import 'dart:convert';


class ReviewModel {
  List<Datum>? data;

  ReviewModel({
    this.data,
  });

  factory ReviewModel.fromRawJson(String str) => ReviewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  List<User>? user;
  String? userId;
  String? reviewerId;
  String? productId;
  String? review;
  double? rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? convertedId;
  String? convertedProductId;

  Datum({
    this.id,
    this.user,
    this.userId,
    this.reviewerId,
    this.productId,
    this.review,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.convertedId,
    this.convertedProductId,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    user: json["user"] == null ? [] : List<User>.from(json["user"]!.map((x) => User.fromJson(x))),
    userId: json["userId"],
    reviewerId: json["reviewerId"],
    productId: json["ProductId"],
    review: json["Review"],
    rating: json["Rating"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    convertedId: json["convertedId"],
    convertedProductId: json["convertedProductId"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x.toJson())),
    "userId": userId,
    "reviewerId": reviewerId,
    "ProductId": productId,
    "Review": review,
    "Rating": rating,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "convertedId": convertedId,
    "convertedProductId": convertedProductId,
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

  User({
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
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
  };
}
