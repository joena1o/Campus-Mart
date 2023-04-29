import 'dart:async';

import 'package:campus_mart/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:campus_mart/Screens/WelcomeScreen/WelcomeScreen.dart';
import 'package:flutter/material.dart';
class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_)=> const OnboardingScreen())
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreen();
  }
}
