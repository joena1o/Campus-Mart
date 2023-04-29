import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: secondary,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark
    ));
    Size size = MediaQuery.of(context).size;
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
                child: Lottie.asset('assets/Lottie/student.json'),
              ),
              const Text("All within your campus", style: TextStyle(color:Colors.white,
                  fontWeight: FontWeight.bold, fontSize: 25),),
              Container(height: 20,),
              const Text(
                  "We connect you with the best deals you can get within your campus",
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Colors.white, fontSize: 16)
              )
            ],
          )),
    );
  }
}
