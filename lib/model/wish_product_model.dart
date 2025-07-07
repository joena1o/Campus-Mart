import 'dart:convert';

class WishProductModel {
  String? id;
  String? username;
  String? productId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? convertedId;
  List<Product>? product;
  List<User>? user;

  WishProductModel({
    this.id,
    this.username,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.convertedId,
    this.product,
    this.user,
  });

  factory WishProductModel.fromRawJson(String str) => WishProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WishProductModel.fromJson(Map<String, dynamic> json) => WishProductModel(
    id: json["_id"],
    username: json["username"],
    productId: json["productId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    convertedId: json["convertedId"],
    product: json["product"] == null ? [] : List<Product>.from(json["product"]!.map((x) => Product.fromJson(x))),
    user: json["user"] == null ? [] : List<User>.from(json["user"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "productId": productId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "convertedId": convertedId,
    "product": product == null ? [] : List<dynamic>.from(product!.map((x) => x.toJson())),
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x.toJson())),
  };
}

class Product {
  String? id;
  String? title;
  String? description;
  String? adCategory;
  String? adType;
  String? condition;
  bool? contactForPrice;
  bool? negotiable;
  String? countryId;
  String? campus;
  int? price;
  List<dynamic>? images;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? state;

  Product({
    this.id,
    this.title,
    this.description,
    this.adCategory,
    this.adType,
    this.condition,
    this.contactForPrice,
    this.negotiable,
    this.countryId,
    this.campus,
    this.price,
    this.images,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.state,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    adCategory: json["adCategory"],
    adType: json["adType"],
    condition: json["condition"],
    contactForPrice: json["contactForPrice"],
    negotiable: json["negotiable"],
    countryId: json["countryId"],
    campus: json["campus"],
    price: json["price"],
    images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
    userId: json["userId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "adCategory": adCategory,
    "adType": adType,
    "condition": condition,
    "contactForPrice": contactForPrice,
    "negotiable": negotiable,
    "countryId": countryId,
    "campus": campus,
    "price": price,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "userId": userId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "state": state,
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
