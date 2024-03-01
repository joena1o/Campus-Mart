class ProductModel{

  String? id;
  String? title;
  String? description;
  String? adCategory;
  String? adType;
  String? condition;
  bool? contactForPrice;
  bool? negotiable;
  int? price;
  List<dynamic>? images;
  String? userId;
  String? countryId;
  List<dynamic>? user;
  String? campus;
  List<dynamic>? wishList;

  ProductModel({
  this.id,
  this.title,
  this.description,
  this.adCategory,
  this.adType,
  this.condition,
  this.contactForPrice,
  this.negotiable,
  this.price,
  this.images,
  this.userId,
  this.countryId,
  this.user,
  this.campus,
  this.wishList
  });


   factory ProductModel.fromJson(Map<String, dynamic> json) {
     return ProductModel(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        adCategory: json['adCategory'],
        adType: json['adType'],
        condition: json['condition'],
        contactForPrice: json['contactForPrice'],
        negotiable: json['negotiable'],
        price: json['price'],
        images: json['images'],
        countryId: json['countryId'],
        userId: json['userId'],
        user: json['user'],
        campus: json['campus'],
        wishList: json['wishlist']
      );
   }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "title": title,
      "description": description,
      "adCategory": adCategory,
      "adType": adType,
      "condition": condition,
      "contactForPrice": contactForPrice ?? false,
      "negotiable": negotiable ?? false,
      "price": price,
      "images": images ?? [],
      "userId": userId,
      "countryId": countryId,
      "campus": campus,
      "wishList": wishList
    };
  }

  Map<String, dynamic> toJson2(){
    return {
      "title": title,
      "description": description,
      "adCategory": adCategory,
      "adType": adType,
      "condition": condition,
      "contactForPrice": contactForPrice ?? false,
      "negotiable": negotiable ?? false,
      "price": price,
      "images": images ?? [],
      "userId": userId,
      "countryId": countryId,
      "campus": campus,
    };
  }



}