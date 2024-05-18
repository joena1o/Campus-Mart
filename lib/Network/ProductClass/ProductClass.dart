import 'dart:convert';
import 'package:campus_mart/Model/AdAlertModel.dart';
import 'package:campus_mart/Model/NotificationModel.dart';
import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/ReviewModel.dart';
import 'package:campus_mart/Model/WishProductModel.dart';
import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';

class ProductClass{

  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  String productEndpoint ="$conn/products";
  String wishListEndpoint = "$conn/wishlist";
  String reviewEndpoint = "$conn/review";
  String addAlertEndpoint = "$conn/alert";
  String getMyProductEndpoint = "$conn/products/myads";
  String getNotificationEndpoint = "$conn/notification";
  String searchAdEndPoint = "$conn/products/search/";

  Map<String, String>?  headers;

  Future getMyProducts(id, pageNumber, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    List<ProductModel>? productModel;
    return networkHelper.get("$getMyProductEndpoint/$id/$pageNumber", headers: headers)
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

  Future fetchProduct(category, index, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    List<ProductModel>? productModel;
    String url = "$conn/products/$category";
    return networkHelper.get(category.toString().isEmpty ? "$productEndpoint/$index" : "$url/$index", headers: headers)
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


  Future searchProduct(query, index, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    List<ProductModel>? productModel;
    return networkHelper.get("$searchAdEndPoint$index/$query", headers: headers)
        .then((dynamic res) async{
          print(res);
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

  Future searchCategoryProduct(query, index, cat, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    List<ProductModel>? productModel;
    return networkHelper.get("$searchAdEndPoint$cat/$index/$query", headers: headers)
        .then((dynamic res) async{
          print(res);
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

  Future addProduct(data, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post(productEndpoint, headers: headers, body: data,
      encoding: Encoding.getByName("utf-8"),)
        .then((dynamic res) async{
          print(res);
      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future editProduct(data, token){
    ProductModel? productModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.put("$productEndpoint/editAd", body: data, headers: headers)
        .then((dynamic res) async{
      productModel = ProductModel.fromJson(res);
      return productModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future updatePaymentStatus(data, token){
    ProductModel? productModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post("$productEndpoint/updatePaidStatus", headers: headers, body: data,
      encoding: Encoding.getByName("utf-8"),)
        .then((dynamic res) async{
      print(res);
      productModel = ProductModel.fromJson(res);
      return productModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future deleteProduct(id, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.delete("$productEndpoint/$id", headers: headers)
        .then((dynamic res) async{
      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }


  Future addToWishlist(data, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post(wishListEndpoint, headers: headers, body: data,
      encoding: Encoding.getByName("utf-8"),)
        .then((dynamic res) async{
      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future fetchWishList(username, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    List<WishProductModel>? productModel;
    return networkHelper.get("$wishListEndpoint/$username", headers: headers)
        .then((dynamic res) async{
      Map<String, dynamic> response = res;
      productModel = response['data']
          .map<WishProductModel>((json) => WishProductModel.fromJson(json))
          .toList();
      return productModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future addReview(data, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post(reviewEndpoint, headers: headers, body: data,
      encoding: Encoding.getByName("utf-8"),)
        .then((dynamic res) async{

      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future getReviews(id, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    ReviewModel? reviewModel;
    return networkHelper.get("$reviewEndpoint/$id", headers: headers)
        .then((dynamic res) async{
          print(res);
      reviewModel = ReviewModel.fromJson(res);
      return reviewModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }


  Future getNotifications(userId, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    List<NotificationModel>? notificationModel;
    return networkHelper.get("$getNotificationEndpoint/$userId", headers: headers)
        .then((dynamic res) async{
          List response = res as List;
          print(res);
      notificationModel = response.map((json)=> NotificationModel.fromJson(json)).toList();
      return notificationModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }


  Future adAlert(data, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post(addAlertEndpoint, headers: headers, body: data,
      encoding: Encoding.getByName("utf-8"),)
        .then((dynamic res) async{
          print(res);
      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future saveSearch(data, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post("$productEndpoint/saveSearch", headers: headers, body: data,
      encoding: Encoding.getByName("utf-8"),)
        .then((dynamic res) async{
      print(res);
      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future getAdAlerts(userId, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    List<AdAlertModel>? adAlert;
    return networkHelper.get("$addAlertEndpoint/$userId", headers: headers)
        .then((dynamic res) async{
      Map<String, dynamic> response = res;
      final result = response['data'] as List;
      adAlert = result.map((json)=>AdAlertModel.fromJson(json)).toList();
      return adAlert;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }


  Future deleteAdAlert(id, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.delete("$addAlertEndpoint/$id", headers: headers)
        .then((dynamic res) async{
      return res;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }


}
