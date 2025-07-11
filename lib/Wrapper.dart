import 'dart:async';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/screens/onboarding_screen/onboarding_screen.dart';
import 'package:campus_mart/screens/welcome_screen/welcome_screen.dart';
import 'package:campus_mart/Utils/save_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      read("user").then((user) {
        if (user == null) {
          _gotoOnBoarding();
        } else {
          final userAuth = UserModel.fromJson(user);
          _loadDetails();
          readValue('passcode').then((passcode) {
            _loginUser(email: userAuth.email!, password: passcode);
          });
        }
      });
    });
  }

  void _gotoOnBoarding() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()));
  }

  void _loadDetails() {
    context.read<UserProvider>().loadDetails();
  }

  void _loginUser({required String email, required String password}) {
    Provider.of<AuthProvider>(context, listen: false)
        .loginUser(email, password, true);
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreen();
  }
}
