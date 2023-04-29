import 'package:campus_mart/Screens/HomeScreen/HomeScreen.dart';
import 'package:campus_mart/Screens/OnboardingScreen/Pages/Page2.dart';
import 'package:campus_mart/Screens/OnboardingScreen/Pages/Page3.dart';
import 'package:campus_mart/Screens/OnboardingScreen/Pages/Page4.dart';
import 'package:campus_mart/Screens/OptionScreen/OptionScreen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends State<OnboardingScreen> {

  int position = 0;
  PageController? pageController;

  @override
  void initState(){
    super.initState();
    init();
  }

  Future<void> init() async {
    pageController =
        PageController(initialPage: position, viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.transparent,
        width: size.width,
        height: size.height,
        child:  PageView(
           physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: const [
              Page2(),
              Page3(),
              Page4()
            ])),
      floatingActionButton: FloatingActionButton(
        backgroundColor: (position%2==1)?secondary:primary,
        onPressed: (){
          setState(() {
            if(position != 2){
              position++;
              pageController!.nextPage(
                  duration: const Duration(microseconds: 300),
                  curve: Curves.linear);
            }else{
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const OptionScreen()));
            }


          });
        },
        child: const Icon(Icons.chevron_right),
      ),
    );
  }
}
