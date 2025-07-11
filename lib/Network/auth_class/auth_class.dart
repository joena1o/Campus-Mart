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

  Future<AuthModel> loginUser(data) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final response = await networkHelper.post(loginEndpoint,
          headers: headers, encoding: Encoding.getByName("utf-8"), body: data);
      if (response.statusCode >= 400 && response.statusCode <= 500) {
        throw response.body;
      }
      final result = json.decode(response.body);
      return AuthModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> createUser(data) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final response = await networkHelper.post(createUserEndpoint,
          headers: headers, encoding: Encoding.getByName("utf-8"), body: data);
      if (response.statusCode >= 400 && response.statusCode <= 500) {
        throw (response.body);
      }
      final result = json.decode(response.body);
      return UserModel.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Campus>> fetchCampuses(state) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.get(campusEndpoint, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      final res = json.decode(result.body) as List;
      return res.map((val) => Campus.fromJson(val)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CountryModel>> fetchCountries() async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.get(countryEndpoint, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      final res = json.decode(result.body) as List;
      return res.map((val) => CountryModel.fromJson(val)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StateModel>> fetchStates(id) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result =
          await networkHelper.get(stateEndpoint + id, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      final res = json.decode(result.body) as List;
      return res.map((val) => StateModel.fromJson(val)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validateMail(email, username) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.post(editProfileEndpoint,
          body: {"email": email, "username": username}, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return json.decode(result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> editProfile(data, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.post(editProfileEndpoint,
          body: data, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return UserModel.fromJson(json.decode(result.body)['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateDp(email, dp, token) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token
    };
    try {
      final result = await networkHelper.get(updateDpUrl, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return json.decode(result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> validateUser(user) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.post(validateUserEndpoint,
          body: {"username": user}, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return json.decode(result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<SuccessMessageModel> requestVerifyEmail(email) async {
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    try {
      final result = await networkHelper.post(requestVerifyEmailUrl,
          body: {"email": email}, headers: headers);
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return SuccessMessageModel.fromJson(json.decode(result.body));
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
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return VerifyTokenModel.fromJson(json.decode(result.body));
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
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return SuccessMessageModel.fromJson(json.decode(result.body));
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
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      return VerifyTokenModel.fromJson(json.decode(result.body));
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
      if (result.statusCode >= 400 && result.statusCode <= 500) {
        throw (result.body);
      }
      successMessageModel =
          SuccessMessageModel.fromJson(json.decode(result.body));
      return successMessageModel;
    } catch (e) {
      rethrow;
    }
  }
}
