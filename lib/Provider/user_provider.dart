import 'dart:convert';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';
import 'package:campus_mart/Utils/savePrefs.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/Wrapper.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{

  UserModel? userDetails;
  Auth auth = Auth();

  String userDp = "";

  bool editingProfile = false;
  bool updatingDp = false;

  void setUserDetails(UserModel _userDetails) async{
    userDetails = _userDetails;
    await saveJsonDetails("user", userDetails);
    if(userDetails?.image !=null){
      userDp = userDetails!.image!;
    }
    notifyListeners();
  }

  void setAccessToken(token) async{
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
      Navigator.pop(context);
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessageError(errorModel.message);
      notifyListeners();
    });
  }

  void editProfile(data, token, context) async{
    editingProfile = true;
    try{
      userDetails = await auth.editProfile(data, token);
      await saveJsonDetails("user", userDetails);
      showMessage("Profile edited successfully");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const Wrapper()));
    }catch(e){
      showMessageError(e.toString());
    }finally{
      editingProfile = false;
    }
    notifyListeners();
  }

}