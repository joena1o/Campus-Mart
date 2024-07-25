import 'dart:async';
import 'package:campus_mart/main.dart';
import 'package:flutter/material.dart';

// Models
import 'package:campus_mart/Model/AuthModel.dart';
import 'package:campus_mart/Model/SuccessMessageModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Model/VerifyOtpModel.dart';

// Network
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';

// Screens
import 'package:campus_mart/Screens/ForgotPasswordScreen/ResetPasswordScreen.dart';
import 'package:campus_mart/Screens/ForgotPasswordScreen/VerifyOtpScreen.dart';
import 'package:campus_mart/Screens/HomeScreen/HomeScreen.dart';
import 'package:campus_mart/Screens/LoginScreen/LoginScreen.dart';
import 'package:campus_mart/Wrapper.dart';

// Utils
import 'package:campus_mart/Utils/savePrefs.dart';
import 'package:campus_mart/Utils/snackBar.dart';

class AuthProvider with ChangeNotifier {
  final Auth _auth = Auth();
  bool _isLoading = false;
  String _accessToken = '';
  String? _resetToken;

  AuthModel? _authModel;
  SuccessMessageModel? _successMessageModel;
  VerifyTokenModel? _verifyTokenModel;

  AuthModel get authModel => _authModel!;

  bool get isLoading => _isLoading;
  String get accessToken => _accessToken;

  set accessToken(String value) {
    _accessToken = value;
    notifyListeners();
  }

  // ----- Login -----
  Future<void> loginUser(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _authModel = await _auth.loginUser({"email": email, "password": password});
      accessToken = _authModel!.auth.toString();

      final UserModel user = UserModel.fromJson(_authModel!.data!.toJson());
      await saveJsonDetails("user", user);

      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      showMessageError(e.toString());
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ----- Email Verification -----
  Future<void> requestVerifyEmailAddress(String email, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _successMessageModel = await _auth.requestVerifyEmail(email);
      showMessage(_successMessageModel?.message);
    } catch (e) {
      showMessageError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyEmailAddress(String otp, String email, BuildContext context, Timer timer) async {
    _isLoading = true;
    notifyListeners();
    final BuildContext storedContext = context;
    try {
      _verifyTokenModel = await _auth.verifyEmailAddressOtp(otp, email);
      timer.cancel();
      showMessage(_verifyTokenModel?.message);
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const Wrapper()));
    } catch (e) {
      showMessageError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ----- Forgot Password -----
  Future<void> requestForgotPassword(String email, BuildContext context, [VoidCallback? callback]) async {
    _isLoading = true;
    notifyListeners();

    try {
      _successMessageModel = await _auth.requestForgottenPasswordOtp(email);
      showMessage(_successMessageModel?.message);
      if (callback == null) {
        navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: email)));
      } else {
        callback();
      }
    } catch (e) {
      showMessageError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String otp, String email, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _verifyTokenModel =await _auth.verifyOtp(otp, email);
      _resetToken = _verifyTokenModel?.token;
      showMessage(_verifyTokenModel?.message);
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const ResetPasswordScreen()));
    } catch (e) {
      showMessageError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _successMessageModel = await _auth.resetPassword(_resetToken!, password);
      showMessage(_successMessageModel?.message);
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      showMessageError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}