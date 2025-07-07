// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:convert';
import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:campus_mart/model/ad_alert_model.dart';
import 'package:campus_mart/model/notification_model.dart';
import 'package:campus_mart/model/product_model.dart';
import 'package:campus_mart/model/review_model.dart';
import 'package:campus_mart/model/success_message_model.dart';
import 'package:campus_mart/model/wish_product_model.dart';

class ProductClass {
  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  String productEndpoint = "$conn/products";
  String wishListEndpoint = "$conn/wishlist";
  String reviewEndpoint = "$conn/review";
  String addAlertEndpoint = "$conn/alert";
  String getMyProductEndpoint = "$conn/products/myads";
  String getMyPendingProductEndpoint = "$conn/products/myPendingAds";
  String getNotificationEndpoint = "$conn/notification";
  String searchAdEndPoint = "$conn/products/search/";

  Map<String, String>? headers;

  Future getMyProducts(id, pageNumber, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper
          .get("$getMyProductEndpoint/$id/$pageNumber", headers: headers);
      Map<String, dynamic> response = result;
      return response['data']
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future getMyPendingProducts(id, pageNumber, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.get(
          "$getMyPendingProductEndpoint/$id/$pageNumber",
          headers: headers);
      Map<String, dynamic> response = result;
      return response['data']
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>?> fetchProducts(category, index, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      String url = "$conn/products/$category";
      final result = await networkHelper.get(
          category.toString().isEmpty
              ? "$productEndpoint/$index"
              : "$url/$index",
          headers: headers);
      Map<String, dynamic> response = result;
      return response['data']
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProduct(query, index, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.get("$searchAdEndPoint$index/$query",
          headers: headers);
      Map<String, dynamic> response = result;
      return response['data']
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> searchCategoryProduct(
      query, index, cat, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper
          .get("$searchAdEndPoint$cat/$index/$query", headers: headers);
      Map<String, dynamic> response = result;
      return response['data']
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future addProduct(data, token) {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper
        .post(
      productEndpoint,
      headers: headers,
      body: data,
      encoding: Encoding.getByName("utf-8"),
    )
        .then((dynamic res) async {
      return res;
    }).catchError((err) {
      errorHandler.handleError(err['body']);
    });
  }

  Future<ProductModel> editProduct(data, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.put("$productEndpoint/editAd",
          body: data, headers: headers);
      return ProductModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> updatePaymentStatus(data, token) async {
    ProductModel? productModel;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.post(
        "$productEndpoint/updatePaidStatus",
        headers: headers,
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
      productModel = ProductModel.fromJson(result);
      return productModel;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteProduct(id, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result =
          await networkHelper.delete("$productEndpoint/$id", headers: headers);
      return result;
    } catch (e) {
      rethrow;
    }
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

  Future<List<WishProductModel>> fetchWishList(username, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.get("$wishListEndpoint/$username",
          headers: headers);
      final response = result['data'] as List;
      return response.map((json) => WishProductModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReview(data, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      await networkHelper.post(
        reviewEndpoint,
        headers: headers,
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ReviewModel> getReviews(id, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result =
          await networkHelper.get("$reviewEndpoint/$id", headers: headers);
      return ReviewModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<NotificationModel>> getNotifications(userId, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.get("$getNotificationEndpoint/$userId",
          headers: headers);
      List response = result as List;
      return response.map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> adAlert(data, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      return await networkHelper.post(
        addAlertEndpoint,
        headers: headers,
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSearch(data, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      await networkHelper.post(
        "$productEndpoint/saveSearch",
        headers: headers,
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AdAlertModel>> getAdAlerts(userId, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final response = await networkHelper.get("$addAlertEndpoint/$userId",
          headers: headers);
      final result = response['data'] as List;
      return result.map((json) => AdAlertModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<SuccessMessageModel> deleteAdAlert(id, token) async {
    SuccessMessageModel? successMessageModel;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final reponse =
          await networkHelper.delete("$addAlertEndpoint/$id", headers: headers);
      successMessageModel = SuccessMessageModel.fromJson(reponse);
      return successMessageModel;
    } catch (e) {
      rethrow;
    }
  }
}
