import 'dart:convert';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/WishProductModel.dart';
import 'package:campus_mart/Network/ProductClass/ProductClass.dart';
import 'package:campus_mart/Utils/Snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ProductProvider extends ChangeNotifier{

  List<WishProductModel>? wishProductModel;
  List<ProductModel>? productList;

  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final RefreshController refreshController2 = RefreshController(initialRefresh: false);

  ProductClass product = ProductClass();
  bool loadingWishList = false;
  bool get isLoadingWishList => loadingWishList;

  bool isGettingProduct = false;
  bool get getIsGettingProduct => isGettingProduct;

  void getWishList(username){
    loadingWishList = true;
    product.fetchWishList(username).then((value){
      loadingWishList = false;
      wishProductModel = value;
      notifyListeners();
    }).catchError((onError){
      loadingWishList = false;
      notifyListeners();
    });
  }

  void getProduct(category,val,context) async{
    isGettingProduct = true;
    await product.fetchProduct(category).then((value){
      isGettingProduct = false;
      productList = value as List<ProductModel>?;
      if(val==1){
        refreshController.loadComplete();
      }else{
        refreshController2.loadComplete();
      }
    }).catchError((onError){
      isGettingProduct = false;
      refreshController2.loadComplete();
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessage(errorModel.message, context);
    });
    notifyListeners();
  }

}