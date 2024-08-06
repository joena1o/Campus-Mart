import 'package:campus_mart/Screens/OnboardingScreen/Pages/page_2.dart';
import 'package:campus_mart/Screens/OnboardingScreen/Pages/page_3.dart';
import 'package:campus_mart/Screens/OnboardingScreen/Pages/page_4.dart';
import 'package:campus_mart/Screens/OnboardingScreen/Pages/selected_preferred_theme.dart';
import 'package:campus_mart/Screens/OptionScreen/option_screen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white24,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark
    ));

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
          shape: const CircleBorder(),
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
