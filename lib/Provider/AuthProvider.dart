import 'dart:convert';
import 'package:campus_mart/Model/AuthModel.dart';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';
import 'package:campus_mart/Screens/HomeScreen/HomeScreen.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _accessToken = '';

  Auth auth = Auth();
  bool isLoading = false;

  String get accessToken => _accessToken;

  set accessToken(String value) {
    _accessToken = value;
    notifyListeners();
  }

  void loginUser(email, password, context) async{
    isLoading = true;
    notifyListeners();
    await auth.loginUser({"email": email, "password": password})
        .then((AuthModel value){
      isLoading = false;
      accessToken = value.auth!;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const HomeScreen()));
    }).catchError((onError){
      isLoading = false;
      ErrorModel error = ErrorModel.fromJson(jsonDecode(onError));
      showMessage(error.message, context);
    });
    notifyListeners();
  }




}