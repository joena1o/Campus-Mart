import 'package:campus_mart/Model/UserModel.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{

  UserModel? userDetails;

  void setUserDetails(UserModel _userDetails){
    userDetails = _userDetails;
    notifyListeners();
  }

}