class WishListModel{

  String? id;
  String? username;
  String? productId;

  WishListModel({
    this.id,
    this.username,
    this.productId
  });

  factory WishListModel.fromJson(Map<String, dynamic> json)=>
      WishListModel(
        id: json['_id'],
        username: json['username'],
        productId: json['productId']
      );


}