import 'dart:convert';
import 'package:campus_mart/Model/AuthModel.dart';
import 'package:campus_mart/Model/CampusModel.dart';
import 'package:campus_mart/Model/CountryModel.dart';
import 'package:campus_mart/Model/StateModel.dart';
import 'package:campus_mart/Model/SuccessMessageModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Model/VerifyOtpModel.dart';
import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';

class Auth{

  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Map<String, String>?  headers;

  String loginEndpoint ="$conn/user/login";
  String campusEndpoint = "$conn/user/getcampus";
  String countryEndpoint = "$conn/user/getCountries";
  String stateEndpoint = "$conn/user/getStates/";
  String validateEmail = "$conn/user/validate_email";
  String updateDpUrl = "$conn/user/updateDp";
  String validateUserEndpoint = "$conn/user/validate_user";
  String createUserEndpoint = "$conn/user/create";
  String editProfileEndpoint = "$conn/user/editProfile";

  String forgottenPasswordUrl  = "$conn/forgot-password/";
  String verifyOtpUrl  = "$conn/forgot-password/verify";
  String resetPasswordUrl = "$conn/forgot-password/reset-password";

  String requestVerifyEmailUrl = "$conn/user/requestVerifyEmail";
  String verifyEmailAddressUrl = "$conn/user/verifyEmailAddress";

  Future<AuthModel> loginUser(data){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    AuthModel authModel = AuthModel();
    return networkHelper.post(loginEndpoint, headers: headers,  encoding: Encoding.getByName("utf-8"), body: data)
        .then((dynamic res) async{
          authModel = AuthModel.fromJson(res);
          return authModel;
        }).catchError((err){
          errorHandler.handleError(err['body']);
        });
  }

  Future<UserModel> createUser(data){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    UserModel userModel = UserModel();
    return networkHelper.post(createUserEndpoint, headers: headers,  encoding: Encoding.getByName("utf-8"), body: data)
        .then((dynamic res) async{
      final response = res;
      userModel = UserModel.fromJson(response);
      return userModel;
    }).catchError((err)=> errorHandler.handleError(err['body']));
  }

  Future fetchCampuses(state){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    List<Campus> campus = [];
    return networkHelper.get("$campusEndpoint/$state", headers: headers)
        .then((dynamic value) async{
          print(value);
          final res = value as List;
          campus = res.map<Campus>((val)=> Campus.fromJson(val)).toList();
          return campus;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future fetchCountries(){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    List<CountryModel> countries = [];
    return networkHelper.get(countryEndpoint, headers: headers)
        .then((dynamic value) async{
      final res = value as List;
      countries = res.map((val)=> CountryModel.fromJson(val)).toList();
      return countries;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future fetchStates(id){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    List<StateModel> states = [];
    return networkHelper.get(stateEndpoint+id, headers: headers)
        .then((dynamic value) async{
      final res = value as List;
      states = res.map((val)=> StateModel.fromJson(val)).toList();
      return states;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future validateMail(email){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(validateEmail, body:{
      "email": email
    }, headers: headers)
        .then((dynamic value) async{
          return true;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
    }


    Future editProfile(data, token){
      headers  = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": token
      };
      return networkHelper.put(editProfileEndpoint, body:data, headers: headers)
          .then((dynamic value) async{
        return UserModel.fromJson(value['data']);
      }).catchError((err){
        errorHandler.handleError(err['body']);
      });
  }


  Future updateDp(email, dp, token){
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post(updateDpUrl, body:{
      "emailField": email,
      "dp": dp
    }, headers: headers)
        .then((dynamic value) async{
      return true;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }


    Future validateUser(user){
      headers  = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };
      return networkHelper.post(validateUserEndpoint, body:{
        "username": user
      }, headers: headers)
          .then((dynamic value) async{
        return true;
      }).catchError((err){
        print(err);
        errorHandler.handleError(err['body']);
      });
    }


  Future requestVerifyEmail(email){
    SuccessMessageModel? successMessageModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(requestVerifyEmailUrl, body:{
      "email": email
    }, headers: headers)
        .then((dynamic value) async{
      successMessageModel = SuccessMessageModel.fromJson(value);
      return successMessageModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future verifyEmailAddressOtp(otp, email){
    VerifyTokenModel? verifyTokenModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(verifyEmailAddressUrl, body:{
      "email": email,
      "otp": otp
    }, headers: headers)
        .then((dynamic value) async{
      verifyTokenModel = VerifyTokenModel.fromJson(value);
      return verifyTokenModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future requestForgottenPasswordOtp(email){
    SuccessMessageModel? successMessageModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(forgottenPasswordUrl, body:{
      "email": email
    }, headers: headers)
        .then((dynamic value) async{
      successMessageModel = SuccessMessageModel.fromJson(value);
      return successMessageModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future verifyOtp(otp, email){
    VerifyTokenModel? verifyTokenModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(verifyOtpUrl, body:{
      "email": email,
      "otp": otp
    }, headers: headers)
        .then((dynamic value) async{
      verifyTokenModel = VerifyTokenModel.fromJson(value);
      return verifyTokenModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }

  Future resetPassword(token, newPassword){
    SuccessMessageModel? successMessageModel;
    headers  = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper.post(resetPasswordUrl, body:{
      "password": newPassword,
    }, headers: headers)
        .then((dynamic value) async{
      successMessageModel = SuccessMessageModel.fromJson(value);
      return successMessageModel;
    }).catchError((err){
      errorHandler.handleError(err['body']);
    });
  }


}

