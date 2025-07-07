import 'dart:convert';
import 'package:campus_mart/Utils/time_and_date.dart';
import 'package:campus_mart/model/ad_alert_model.dart';
import 'package:campus_mart/model/error_model.dart';
import 'package:campus_mart/model/notification_model.dart';
import 'package:campus_mart/model/product_model.dart';
import 'package:campus_mart/model/review_model.dart';
import 'package:campus_mart/model/success_message_model.dart';
import 'package:campus_mart/model/wish_product_model.dart';
import 'package:campus_mart/network/product_class/product_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_payment_plus/flutter_paystack_payment_plus.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:campus_mart/Utils/snackbars.dart';

class ProductProvider extends ChangeNotifier {
  final ProductClass _product = ProductClass();

  final plugin = PaystackPayment();

  List<WishProductModel>? _wishProductModel;
  List<ProductModel> _productList = [];
  List<ProductModel> _pendingAdsList = [];
  List<ProductModel> _categoryProductList = [];
  List<NotificationModel> _notificationList = [];
  List<AdAlertModel>? _adAlertList = [];
  List<ProductModel> _myProductList = [];
  List<WishProductModel> _availableItems = [];

  ReviewModel? _reviews;
  String? _currentCategory;

  bool _loadingWishList = false;
  bool _loadingReviews = false;
  bool _isGettingProduct = false;
  bool _isGettingMyProduct = false;
  bool _uploadingReview = false;
  bool _loadingNotifications = false;
  bool _uploadingAdAlert = false;
  bool _fetchAdAlerts = true;
  bool _deleteAdAlertStatus = false;

  int _indexAll = 1;
  int _indexCat = 1;
  final int _searchIndex = 1;
  int _myAdsIndex = 1;
  int _pendingAdsIndex =1;

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final RefreshController _refreshController2 = RefreshController(initialRefresh: false);

  // Getters
  List<WishProductModel>? get wishProductModel => _wishProductModel;
  List<ProductModel> get productList => _productList;
  List<ProductModel> get pendingAdsList => _pendingAdsList;
  List<ProductModel> get categoryProductList => _categoryProductList;
  List<NotificationModel> get notificationList => _notificationList;
  List<AdAlertModel>? get adAlertList => _adAlertList;
  List<ProductModel> get myProductList => _myProductList;
  List<WishProductModel> get availableItems => _availableItems;
  ReviewModel? get reviews => _reviews;
  String? get currentCategory => _currentCategory;

  bool get isLoadingWishList => _loadingWishList;
  bool get isLoadingReviews => _loadingReviews;
  bool get isGettingProduct => _isGettingProduct;
  bool get isGettingMyProduct => _isGettingMyProduct;
  bool get isUploadingReview => _uploadingReview;
  bool get isLoadingNotifications => _loadingNotifications;
  bool get isUploadingAlert => _uploadingAdAlert;
  bool get isFetchingAdAlerts => _fetchAdAlerts;
  bool get isDeletingAdAlert => _deleteAdAlertStatus;

  RefreshController get refreshController => _refreshController;
  RefreshController get refreshController2 => _refreshController2;

  // ----- Wishlist -----
  Future<void> getWishList(String? username, String token) async {
    _loadingWishList = true;
    try {
      _wishProductModel = await _product.fetchWishList(username, token);
      _availableItems = _wishProductModel!.where((element) => element.product!.isNotEmpty).toList();
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
      _wishProductModel = [];
    } finally {
      _loadingWishList = false;
      notifyListeners();
    }
  }

  // ----- My Ads -----
  void resetMyAdsItems() {
    _myAdsIndex = 1;
    _pendingAdsIndex = 1;
    _myProductList = [];
    _pendingAdsList = [];
  }

  Future<void> _getMoreAds(String id, String token, bool isPending) async {
    try {
      final List<ProductModel> newAds = isPending
          ? await _product.getMyPendingProducts(id, _pendingAdsIndex, token)
          : await _product.getMyProducts(id, _myAdsIndex, token);

      if (newAds.isNotEmpty) {
        if (isPending) {
          _pendingAdsList.addAll(newAds);
          _pendingAdsIndex++;
        } else {
          _myProductList.addAll(newAds);
          _myAdsIndex++;
        }
      }
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _refreshController.loadComplete();
    }
  }

  Future<void> getMyAds(String? id, String token) async {
    _isGettingMyProduct = true;
    await _getMoreAds(id!, token, false);
    _isGettingMyProduct = false;
    notifyListeners();
  }


  Future<void> deleteAd(String? id, String? userId, String token) async {
    _isGettingMyProduct = true;
    try {
      final String response = await _product.deleteProduct(id, token);
      final SuccessMessageModel successMessage = SuccessMessageModel.fromJson(jsonDecode(response));
      showMessage(successMessage.message);
      resetMyAdsItems();
      getMyAds(userId, token);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isGettingMyProduct = false;
      notifyListeners();
    }
  }

  // ----- Ad Alerts -----
  Future<void> addAdAlert(BuildContext context, Map<String, dynamic> data, String userId, String token) async {
    _uploadingAdAlert = true;
    try {
      final dynamic response = await _product.adAlert(data, token);
        final SuccessMessageModel result = SuccessMessageModel.fromJson(response);
        showMessage(result.message);
        getAdAlerts(userId, token);
    } catch (onError) {
      final ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError as String));
      showMessage(errorModel.message);
    } finally {
      _uploadingAdAlert = false;
      notifyListeners();
    }
  }

  Future<void> getAdAlerts(String userId, String token) async {
    _adAlertList = [];
    _fetchAdAlerts = true;
    try {
      _adAlertList = await _product.getAdAlerts(userId, token);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _fetchAdAlerts = false;
      notifyListeners();
    }
  }

  Future<void> deleteAdAlert(String? id, BuildContext context, String? userId, String token) async {
    _deleteAdAlertStatus = true;
    try {
      final dynamic successMessage = await _product.deleteAdAlert(id, token);
      showMessage(successMessage);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _deleteAdAlertStatus = false;
      notifyListeners();
    }
  }

  // ----- Reviews -----
  Future<void> getUserReviews(String? id, String? token) async {
    _loadingReviews = true;
    try {
      _reviews = await _product.getReviews(id, token);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _loadingReviews = false;
      notifyListeners();
    }
  }

  Future<void> addReview(Map<String, dynamic> data, String token) async {
    _uploadingReview= true;
    try {
      await _product.addReview(data, token);
    } catch (e) {
      // Handle error
        showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _uploadingReview = false;
      notifyListeners();
    }
  }


  // ----- Notifications -----
  Future<void> getNotifications(String? userId, String token) async {
    _loadingNotifications = true;
    try {
      _notificationList = await _product.getNotifications(userId, token);
      _notificationList.sort(compareTimestamps);
      _notificationList = _notificationList.reversed.toList();
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _loadingNotifications = false;
      notifyListeners();
    }
  }

  // ----- Products -----
  void resetItems() {
    _indexCat = 1;
    _categoryProductList = [];
    notifyListeners();
  }

  void resetMyProduct() {
    _indexAll = 1;
    _productList = [];
    notifyListeners();
  }

  Future<void> searchProduct(String? query, String token, BuildContext context) async {
    _categoryProductList = [];
    _isGettingProduct =true;
    try {
      _categoryProductList = await _product.searchProduct(query, _searchIndex, token);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isGettingProduct = false;
      notifyListeners();
    }
  }

  Future<void> searchProductByCategory(String? query, String token, BuildContext context) async {
    _categoryProductList = [];
    _isGettingProduct = true;
    try {
      _categoryProductList = await _product.searchCategoryProduct(query, _searchIndex, _currentCategory!, token);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isGettingProduct = false;
      notifyListeners();
    }
  }

  Future<void> _getMoreProducts(String category, String token, bool isAll) async {
    try {
      final List<ProductModel>? newProducts = await _product.fetchProducts(category, isAll ? _indexAll : _indexCat, token);
      if (newProducts!.isNotEmpty) {
        if (isAll) {
          _productList.addAll(newProducts);
          _indexAll++;
        } else {
          _categoryProductList.addAll(newProducts);
          _indexCat++;
        }
      }
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    }
  }

  Future<void> getProduct(String? category, int val, String token, Function callback) async {
    _isGettingProduct = true;
    try {
      await _getMoreProducts(category!, token, category.isEmpty);
    } catch (onError) {
      final ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError as String));
      showMessageError(errorModel.message);
    } finally {
      _isGettingProduct = false;
      callback();
      notifyListeners();
    }
  }

  // ----- Edit Ad -----
  Future<void> editProduct(Map<String, dynamic> data, String token, VoidCallback onSuccess) async {
    _isGettingProduct = true;
    try {
      await _product.editProduct(data, token);
      onSuccess();
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isGettingProduct = false;
      notifyListeners();
    }
  }

  // ----- Save Search -----
  Future<void> saveSearch(Map<String, dynamic> data, String token) async {
    await _product.saveSearch(data, token);
  }

  void disposeControllers(){
    _refreshController.dispose();
    _refreshController2.dispose();
  }

}

