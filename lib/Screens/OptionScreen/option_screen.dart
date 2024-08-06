import 'package:campus_mart/Screens/HomeScreen/home_screen.dart';
import 'package:campus_mart/Screens/LoginScreen/login_screen.dart';
import 'package:campus_mart/Screens/SignUpScreen/sign_up_screen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white24,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: size.width*.1),
        decoration: const BoxDecoration(

        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                width: 100,
                height: 100,
                child: const Image(image: AssetImage('assets/logo_orange.png',
                ),),
              ),

              Container(
                margin: const EdgeInsets.only(top: 70, bottom: 20),
              ),
              Container(
                child: const Text("Connect with buyers and sellers within your school with ease.",
                textAlign: TextAlign.center, style: TextStyle(color: primary,fontSize: 16),),
              ),

              Container(height: size.height*.14,),

              GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> const LoginScreen())
                    );
                  },
                  child:Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        primary,
                        secondary,
                      ],
                    ),
                  borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 50),
                width: size.width,
                child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white), textAlign: TextAlign.center,),
              )),

          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_)=> const SignUpScreen())
              );
            },
            child:Container(
                decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 20),
                width: size.width,
                child: const Text("Sign Up", style: TextStyle( fontSize: 18), textAlign: TextAlign.center,),
              ))
            ],
          ),
    )

    );
  }
}
