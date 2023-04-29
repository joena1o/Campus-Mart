import 'dart:convert';
import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/WishProductModel.dart';
import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';

class ProductClass{

  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();
  String productEndpoint ="${conn}/products";
  String wishListEndpoint = "${conn}/wishlist";

  Future fetchProduct(category){
    List<ProductModel>? productModel;
    Map<String, String> headers;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    String url = "${conn}/products/$category";

    return networkHelper.get(category==null ? productEndpoint : url, headers: headers)
        .then((dynamic res) async{
      Map<String, dynamic> response = res;
      productModel = response['data']
          .map<ProductModel>(
              (json) => ProductModel.fromJson(json))
          .toList();
      return productModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future addProduct(data){
    Map<String, String> headers;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(productEndpoint, headers: headers, body: data,
      encoding: Encoding.getByName("utf-8"),)
        .then((dynamic res) async{
      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future addToWishlist(data){
    Map<String, String> headers;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(wishListEndpoint, headers: headers, body: data,
      encoding: Encoding.getByName("utf-8"),)
        .then((dynamic res) async{
      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future fetchWishList(username){
    List<WishProductModel>? productModel;
    Map<String, String> headers;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.get("$wishListEndpoint/$username", headers: headers)
        .then((dynamic res) async{
      Map<String, dynamic> response = res;
      print(response);
      productModel = response['data']
          .map<WishProductModel>(
              (json) => WishProductModel.fromJson(json))
          .toList();
      return productModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

}
