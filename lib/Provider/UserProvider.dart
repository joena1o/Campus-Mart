import 'dart:convert';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';
import 'package:campus_mart/Utils/savePrefs.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{

  UserModel? userDetails;
  Auth user = Auth();

  bool updatingDp = false;
  String userDp = "";

  bool editingProfile = false;

  void setUserDetails(UserModel _userDetails, pass) async{
    userDetails = _userDetails;
    await saveJsonDetails("user", userDetails);
    await saveDetails("passcode", pass);
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
    user.updateDp(email, image, token).then((value){
      updatingDp = false;
      userDp = image;
      Navigator.pop(context);
      notifyListeners();
    }).catchError((onError){
      updatingDp = false;
      Navigator.pop(context);
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
      showMessage(errorModel.message, context);
      notifyListeners();
    });
  }

  void editProfile(data, token, context) async{
    editingProfile = true;
    try{
      userDetails = await user.editProfile(data, token);
      await saveJsonDetails("user", userDetails);
      Navigator.pop(context);
    }catch(e){
      showMessage(e.toString(), context);
    }finally{
      editingProfile = false;
    }
    notifyListeners();
  }

}