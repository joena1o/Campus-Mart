import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: secondary,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark
    ));
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(color: secondary),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width*.6,
                height: size.width*.6,
                child: Lottie.asset('assets/Lottie/sales.json'),
              ),

              const Text("Sell at ease", style: TextStyle(color:Colors.white,
                  fontWeight: FontWeight.bold, fontSize: 25),),
              Container(height: 20,),
              const Text(
                  "Advertise products you wish to sell and connect with buyers",
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Colors.white, fontSize: 16, letterSpacing: 2)
              )
            ],
          )),
    );
  }
}

