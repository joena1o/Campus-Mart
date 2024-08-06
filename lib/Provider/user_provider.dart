import 'dart:convert';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/SuccessMessageModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';
import 'package:campus_mart/Network/SettingClass/setting_class.dart';
import 'package:campus_mart/Utils/save_prefs.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/Wrapper.dart';
import 'package:campus_mart/main.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{

  UserModel? userDetails;
  SuccessMessageModel? successMessageModel;

  Auth auth = Auth();
  SettingClass settingClass = SettingClass();

  String userDp = "";

  bool editingProfile = false;
  bool updatingDp = false;


  Future<void> setUserDetails(UserModel userDetailsParam) async{
    userDetails = userDetailsParam;
    await saveJsonDetails("user", userDetails);
    if(userDetails?.image !=null){
      userDp = userDetails!.image!;
    }
    notifyListeners();
  }

  Future<void> setAccessToken(token) async{
    await saveDetails("accessToken", token);
    notifyListeners();
  }

  void loadDetails(){
    read("user").then((value){
      userDetails = UserModel.fromJson2(value);
      if(userDetails?.image !=null){
        userDp = userDetails!.image!;
      }
      notifyListeners();
    });
  }

  void updateDp(email, image, token, context){
    updatingDp = true;
    auth.updateDp(email, image, token).then((value){
      updatingDp = false;
      userDp = image;
      Navigator.pop(context);
      notifyListeners();
    }).catchError((onError){
      updatingDp = false;
      navigatorKey.currentState?.pop();
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessageError(errorModel.message);
      notifyListeners();
    });
  }

  Future<void> editProfile(data, token, context) async{
    editingProfile = true;
    try{
      userDetails = await auth.editProfile(data, token);
      await saveJsonDetails("user", userDetails);
      showMessage("Profile updated successfully");
      navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (_)=> const Wrapper()));
    }catch(e){
      showMessageError(jsonDecode(e.toString())['message']);
    }finally{
      editingProfile = false;
    }
    notifyListeners();
  }

  Future<void> changePassword(data, token) async{
    editingProfile = true;
    notifyListeners();
    try{
      successMessageModel = await settingClass.changePassword(data, token);
      navigatorKey.currentState?.pop();
      showMessage(successMessageModel?.message);
    }catch(e){
      showMessageError(jsonDecode(e.toString())['message']);
    }finally{
      editingProfile = false;
    }
    notifyListeners();
  }

}