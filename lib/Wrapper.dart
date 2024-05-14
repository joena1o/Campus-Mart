import 'dart:async';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:campus_mart/Screens/WelcomeScreen/WelcomeScreen.dart';
import 'package:campus_mart/Utils/savePrefs.dart';
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
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 4), () {
      read("user").then((user){
        if(user==null){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_)=> const OnboardingScreen())
          );
        }else{
          final userAuth = UserModel.fromJson(user);
          context.read<UserProvider>().loadDetails();
          readValue('passcode').then((passcode){
            Provider.of<AuthProvider>(context, listen: false).loginUser(userAuth!.email, passcode, context);
          });
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreen();
  }


}
