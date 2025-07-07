import 'dart:async';
import 'dart:convert';
import 'package:campus_mart/Wrapper.dart';
import 'package:campus_mart/main.dart';
import 'package:campus_mart/network/auth_class/auth_class.dart';
import 'package:campus_mart/screens/forgot_password_screen/reset_password_screen.dart';
import 'package:campus_mart/screens/forgot_password_screen/verify_otp_screen.dart';
import 'package:campus_mart/screens/home_screen/home_screen.dart';
import 'package:campus_mart/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:campus_mart/Model/AuthModel.dart';
import 'package:campus_mart/Model/SuccessMessageModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Model/VerifyOtpModel.dart';

import 'package:campus_mart/Utils/save_prefs.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthProvider with ChangeNotifier {
  final Auth _auth = Auth();

  bool _isLoading = false;
  String _accessToken = '';
  String? _resetToken;

  AuthModel? _authModel;
  UserModel? _userModel;

  SuccessMessageModel? _successMessageModel;
  VerifyTokenModel? _verifyTokenModel;

  AuthModel get authModel => _authModel!;
  UserModel get userModel => _userModel!;

  bool get isLoading => _isLoading;
  String get accessToken => _accessToken;

  set accessToken(String value) {
    _accessToken = value;
    notifyListeners();
  }

  // ----- Login -----
  Future<void> loginUser(String email, String password, bool redirect) async {
    _isLoading = true;
    notifyListeners();
    try {
      _authModel =
          await _auth.loginUser({"email": email, "password": password});
      accessToken = _authModel!.auth.toString();

      _userModel = UserModel.fromJson(_authModel!.data!.toJson());
      await saveJsonDetails("user", _userModel);
      await saveDetails("passcode", password);

      //Register id for push notification
      OneSignal.shared.setExternalUserId(_authModel!.data!.id!);

      navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      if (redirect) {
        navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ----- Email Verification -----
  Future<void> requestVerifyEmailAddress(
      String email, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _successMessageModel = await _auth.requestVerifyEmail(email);
      showMessage(_successMessageModel?.message);
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyEmailAddress(String otp, String email, Timer timer) async {
    _isLoading = true;
    try {
      _verifyTokenModel = await _auth.verifyEmailAddressOtp(otp, email);
      timer.cancel();
      showMessage(_verifyTokenModel?.message);
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (_) => const Wrapper()));
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ----- Forgot Password -----
  Future<void> requestForgotPassword(String email, BuildContext context,
      [VoidCallback? callback]) async {
    _isLoading = true;
    try {
      _successMessageModel = await _auth.requestForgottenPasswordOtp(email);
      showMessage(_successMessageModel?.message);
      if (callback == null) {
        navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: email)));
      } else {
        callback();
      }
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String otp, String email, BuildContext context) async {
    _isLoading = true;
    try {
      _verifyTokenModel = await _auth.verifyOtp(otp, email);
      _resetToken = _verifyTokenModel?.token;
      showMessage(_verifyTokenModel?.message);
      navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const ResetPasswordScreen()));
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String password, BuildContext context) async {
    _isLoading = true;
    try {
      _successMessageModel = await _auth.resetPassword(_resetToken!, password);
      showMessage(_successMessageModel?.message);
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      showMessageError(jsonDecode(e.toString())['message']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
