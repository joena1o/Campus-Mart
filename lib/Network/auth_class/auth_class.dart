import 'dart:convert';
import 'package:campus_mart/Network/error_handler.dart';
import 'package:campus_mart/Network/network_util.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:campus_mart/model/auth_model.dart';
import 'package:campus_mart/model/campus_model.dart';
import 'package:campus_mart/model/country_model.dart';
import 'package:campus_mart/model/state_model.dart';
import 'package:campus_mart/model/success_message_model.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/model/verify_otp_model.dart';

class Auth {
  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Map<String, String>? headers;

  String loginEndpoint = "$conn/user/login";
  String campusEndpoint = "$conn/user/getcampus";
  String countryEndpoint = "$conn/user/getCountries";
  String stateEndpoint = "$conn/user/getStates/";
  String validateEmail = "$conn/user/validate_email_user";
  String updateDpUrl = "$conn/user/updateDp";
  String validateUserEndpoint = "$conn/user/validate_user";
  String createUserEndpoint = "$conn/user/create";
  String editProfileEndpoint = "$conn/user/editProfile";

  String forgottenPasswordUrl = "$conn/forgot-password/";
  String verifyOtpUrl = "$conn/forgot-password/verify";
  String resetPasswordUrl = "$conn/forgot-password/reset-password";

  String requestVerifyEmailUrl = "$conn/user/requestVerifyEmail";
  String verifyEmailAddressUrl = "$conn/user/verifyEmailAddress";

  Future<AuthModel> loginUser(data) {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    AuthModel authModel = AuthModel();
    return networkHelper
        .post(loginEndpoint,
            headers: headers, encoding: Encoding.getByName("utf-8"), body: data)
        .then((dynamic res) async {
      authModel = AuthModel.fromJson(res);
      return authModel;
    }).catchError((err) {
      errorHandler.handleError(err['body']);
    });
  }

  Future<UserModel> createUser(data) {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    UserModel userModel = UserModel();
    return networkHelper
        .post(createUserEndpoint,
            headers: headers, encoding: Encoding.getByName("utf-8"), body: data)
        .then((dynamic res) async {
      final response = res;
      userModel = UserModel.fromJson(response);
      return userModel;
    }).catchError((err) => throw err);
  }

  Future fetchCampuses(state) {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    List<Campus> campus = [];
    return networkHelper
        .get("$campusEndpoint/$state", headers: headers)
        .then((dynamic value) async {
      final res = value as List;
      campus = res.map<Campus>((val) => Campus.fromJson(val)).toList();
      return campus;
    }).catchError((err) {
      errorHandler.handleError(err['body']);
    });
  }

  Future fetchCountries() {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    List<CountryModel> countries = [];
    return networkHelper
        .get(countryEndpoint, headers: headers)
        .then((dynamic value) async {
      final res = value as List;
      countries = res.map((val) => CountryModel.fromJson(val)).toList();
      return countries;
    }).catchError((err) {
      errorHandler.handleError(err['body']);
    });
  }

  Future fetchStates(id) {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    List<StateModel> states = [];
    return networkHelper
        .get(stateEndpoint + id, headers: headers)
        .then((dynamic value) async {
      final res = value as List;
      states = res.map((val) => StateModel.fromJson(val)).toList();
      return states;
    }).catchError((err) {
      errorHandler.handleError(err['body']);
    });
  }

  Future validateMail(email, username) {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper
        .post(validateEmail,
            body: {"email": email, "username": username}, headers: headers)
        .then((dynamic value) async {
      return true;
    }).catchError((err) => throw err);
  }

  Future editProfile(data, token) {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper
        .put(editProfileEndpoint, body: data, headers: headers)
        .then((dynamic value) async {
      return UserModel.fromJson(value['data']);
    }).catchError((err) {
      errorHandler.handleError(err['body']);
    });
  }

  Future updateDp(email, dp, token) {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    return networkHelper
        .post(updateDpUrl,
            body: {"emailField": email, "dp": dp}, headers: headers)
        .then((dynamic value) async {
      return true;
    }).catchError((err) {
      errorHandler.handleError(err['body']);
    });
  }

  Future<dynamic> validateUser(user) async{
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try{
      final result = await networkHelper
        .post(validateUserEndpoint, body: {"username": user}, headers: headers);
        return result;
    }catch(e){
      rethrow;
    }
  }

  Future requestVerifyEmail(email) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.post(requestVerifyEmailUrl,
          body: {"email": email}, headers: headers);
      return SuccessMessageModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<VerifyTokenModel?> verifyEmailAddressOtp(otp, email) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.post(verifyEmailAddressUrl,
          body: {"email": email, "otp": otp}, headers: headers);
      return VerifyTokenModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<SuccessMessageModel?> requestForgottenPasswordOtp(email) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.post(forgottenPasswordUrl,
          body: {"email": email}, headers: headers);
      return SuccessMessageModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<VerifyTokenModel?> verifyOtp(otp, email) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.post(verifyOtpUrl,
          body: {"email": email, "otp": otp}, headers: headers);
      return VerifyTokenModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<SuccessMessageModel?> resetPassword(token, newPassword) async {
    SuccessMessageModel? successMessageModel;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.post(resetPasswordUrl,
          body: {
            "password": newPassword,
          },
          headers: headers);
      successMessageModel = SuccessMessageModel.fromJson(result);
      return successMessageModel;
    } catch (e) {
      rethrow;
    }
  }
}
