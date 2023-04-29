import 'package:campus_mart/Screens/LoginScreen/LoginScreen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/states.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int position = 0;
  PageController? pageController;

  List<dynamic> campusList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    pageController = PageController(initialPage: position, viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * .08),
          child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [firstStep(size), secondStep(size)])),
    );
  }

  Widget firstStep(size) {
    return SingleChildScrollView(child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: kToolbarHeight * 2,
        ),
        const Text("Create an account",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        Container(
          height: 10,
        ),
        const Text("Let's get started", style: TextStyle(fontSize: 16)),
        Container(
          height: 30,
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: "First Name"),
        ),
        Container(
          height: 20,
        ),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(hintText: "Last Name"),
        ),
        Container(
          height: 20,
        ),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(hintText: "Email Address"),
        ),
        Container(
          height: 20,
        ),

        Container(
          height: 20,
        ),

        DropdownButton(
          //value: biller,
          hint:
          SizedBox(width: size.width * .75, child: const Text("Select State")),
          icon: const Icon(Icons.keyboard_arrow_down),
          underline: Container(),
          items: states.map((dynamic item) {
            return DropdownMenuItem(
              value: item,
              child: SizedBox(width: size.width * .75, child: Text(item)),
            );
          }).toList(),
          onChanged: (dynamic? newValue) {},
        ),

        const Divider(color: Colors.black54),

        Container(
          height: 20,
        ),


        DropdownButton(
          //value: biller,
          hint:
          SizedBox(width: size.width * .75, child: const Text("Fetching Campuses")),
          icon: const Icon(Icons.keyboard_arrow_down),
          underline: Container(),
          items: campusList.map((dynamic item) {
            print(item);
            return DropdownMenuItem(
              value: item,
              child: SizedBox(width: size.width * .75, child: const Text('Campus')),
            );
          }).toList(),
          onChanged: (dynamic? newValue) {},
        ),

        const Divider(color: Colors.black54),

        GestureDetector(
          onTap: () {
            position++;
            pageController!.nextPage(
                duration: const Duration(microseconds: 300),
                curve: Curves.linear);
          },
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.all(20),
              width: size.width,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: [
                      primary,
                      secondary,
                    ],
                  ),
                  color: primary,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text("Continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 17))),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              GestureDetector(
                  onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen())),
                  child: const Text("Sign In", style: TextStyle(color: primary),)
              )
            ],
          ),
        ),
        Container(
          height: size.height * .07,
        ),
      ],
    ));
  }

  Widget secondStep(size) {
    return SingleChildScrollView(child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: kToolbarHeight * 2,
        ),
        const Text("Create an account",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        Container(
          height: 10,
        ),
        const Text("Let's get started", style: TextStyle(fontSize: 16)),
        Container(
          height: 30,
        ),
        TextFormField(
          decoration: const InputDecoration(hintText: "Phone number"),
        ),


        Container(
          height: 20,
        ),
        TextFormField(
          obscureText: true,
          decoration:
              const InputDecoration(hintText: "Enter preferred username "),
        ),
        Container(
          height: 20,
        ),
        TextFormField(
          obscureText: true,
          decoration:
          const InputDecoration(hintText: "Enter password"),
        ),

        Container(
          height: 20,
        ),
        TextFormField(
          obscureText: true,
          decoration:
          const InputDecoration(hintText: "Confirm password"),
        ),
        Container(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.all(20),
              width: size.width,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: [
                      primary,
                      secondary,
                    ],
                  ),
                  color: primary,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text("Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 17))),
        ),
        Container(
          height: size.height * .1,
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              GestureDetector(
                  onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen())),
                  child: const Text("Sign In", style: TextStyle(color: primary),)
              )
            ],
          ),
        )
      ],
    ));
  }
}
