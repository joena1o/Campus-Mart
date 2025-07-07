import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../Utils/colors.dart';

class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: primary,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark
    ));
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(color: primary),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width*.6,
                height: size.width*.6,
                child: Lottie.asset('assets/Lottie/product.json'),
              ),
              const Text("Buy at ease", style: TextStyle(color:Colors.white,
                  fontWeight: FontWeight.bold, fontSize: 25),),
              Container(height: 20,),
              const Text(
                  "Find and connect with sellers",
                  textAlign: TextAlign.center,
                  style: TextStyle(color:Colors.white, fontSize: 16)
              )
            ],
          )),
    );
  }
}
