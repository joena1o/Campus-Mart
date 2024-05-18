import 'dart:async';
import 'package:campus_mart/Model/AuthModel.dart';
import 'package:campus_mart/Model/SuccessMessageModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Model/VerifyOtpModel.dart';
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';
import 'package:campus_mart/Screens/ForgotPasswordScreen/ResetPasswordScreen.dart';
import 'package:campus_mart/Screens/ForgotPasswordScreen/VerifyOtpScreen.dart';
import 'package:campus_mart/Screens/HomeScreen/HomeScreen.dart';
import 'package:campus_mart/Screens/LoginScreen/LoginScreen.dart';
import 'package:campus_mart/Utils/savePrefs.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:campus_mart/Wrapper.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {

  String _accessToken = '';

  Auth auth = Auth();
  bool isLoading = false;

  AuthModel? authModel;
  SuccessMessageModel? successMessageModel;
  VerifyTokenModel? verifyTokenModel;

  String get accessToken => _accessToken;
  String? resetToken;

  set accessToken(String value) {
    _accessToken = value;
    notifyListeners();
  }

  void loginUser(email, password, context, callback) async{
    isLoading = true;
    notifyListeners();
    try{
      authModel = await auth.loginUser({"email": email, "password": password});
      accessToken = authModel!.auth.toString();
      await saveJsonDetails("user", UserModel.fromJson(authModel!.data!.toJson()));
      callback(UserModel.fromJson(authModel!.data!.toJson()), password);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const HomeScreen()));
    }catch(e){
      showMessage(e.toString(), context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen()));
    }finally{
      isLoading = false;
    }
    notifyListeners();
  }

  void requestVerifyEmailAddress(email, context) async{
    isLoading = true;
    try{
      successMessageModel = await auth.requestVerifyEmail(email);
      showMessage(successMessageModel?.message, context);
    }catch(e){
      showMessageError(e.toString(), context);
    }finally{
      isLoading = false;
    }
    notifyListeners();
  }


  void verifyEmailAddress(otp, email, context, Timer timer) async{
    isLoading = true;
    notifyListeners();
    try{
      verifyTokenModel = await auth.verifyEmailAddressOtp(otp, email);
      timer.cancel();
      showMessage(verifyTokenModel?.message, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const Wrapper()));
    }catch(e){
      showMessageError(e.toString(), context);
    }finally{
      isLoading = false;
    }
    notifyListeners();
  }

  void requestForgotPassword(email, context, callback) async{
    isLoading = true;
    notifyListeners();
    try{
      successMessageModel = await auth.requestForgottenPasswordOtp(email);
      showMessage(successMessageModel?.message, context);
      if(callback == null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>  VerifyOtpScreen(email: email,)));
      }else{
        callback();
      }
    }catch(e){
      showMessageError(e.toString(), context);
    }finally{
      isLoading = false;
    }
    notifyListeners();
  }

  void verifyOtp(otp, email, context) async{
    isLoading = true;
    notifyListeners();
    try{
      verifyTokenModel = await auth.verifyOtp(otp, email);
      setResetToken(verifyTokenModel?.token);
      showMessage(verifyTokenModel?.message, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const ResetPasswordScreen()));
    }catch(e){
      showMessageError(e.toString(), context);
    }finally{
      isLoading = false;
    }
    notifyListeners();
  }

  setResetToken(token){
    resetToken = token;
  }

  void resetPassword(password, context) async{
    isLoading = true;
    notifyListeners();
    try{
      successMessageModel = await auth.resetPassword(resetToken, password);
      showMessage(successMessageModel?.message, context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen()));
    }catch(e){
      showMessageError(e.toString(), context);
    }finally{
      isLoading = false;
    }
    notifyListeners();
  }



}