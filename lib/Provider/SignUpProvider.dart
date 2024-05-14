import 'dart:convert';
import 'package:campus_mart/Model/CampusModel.dart';
import 'package:campus_mart/Model/CountryModel.dart';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/StateModel.dart';
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';
import 'package:campus_mart/Screens/LoginScreen/LoginScreen.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier{

  List<Campus> campuses = [];
  bool loadingCampus = false;

  List<StateModel> states = [];
  bool loadingStates = false;

  List<CountryModel>? countries;
  bool loadingCountries = false;


  bool validatingMail = false;
  Auth auth =  Auth();

  bool signingUser = false;
  bool get getSigningUser => signingUser;

  void fetchCampuses(state,context){
    loadingCampus = true;
    auth.fetchCampuses(state).then((value){
      loadingCampus = false;
      campuses = value;
      notifyListeners();
    }).catchError((onError){
      loadingCampus = false;
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessageError(errorModel.message, context);
      notifyListeners();
    });
  }

  void fetchCountries(context){
    loadingCountries = true;
    auth.fetchCountries().then((value){
      loadingCountries = false;
      countries = value;
      notifyListeners();
    }).catchError((onError){
      loadingCountries = false;
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessageError(errorModel.message, context);
      notifyListeners();
    });
  }

  void fetchStates(context, countryId){
    loadingStates = true;
    auth.fetchStates(countryId).then((value){
      loadingStates = false;
      states = value;
      notifyListeners();
    }).catchError((onError){
      loadingStates = false;
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessageError(errorModel.message, context);
      notifyListeners();
    });
  }

  void signUpUser(data, context){
    signingUser = true;
    notifyListeners();
    auth.createUser(data).then((value){
      signingUser = false;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen()));
      notifyListeners();
    }).catchError((onError){
      signingUser = false;
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessageError(errorModel.message, context);
      notifyListeners();
    });
  }

}