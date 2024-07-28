import 'dart:convert';
import 'package:campus_mart/Model/AuthModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/AuthClass/AuthClass.dart';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Screens/ForgotPasswordScreen/ForgotPasswordScreen.dart';
import 'package:campus_mart/Screens/HomeScreen/HomeScreen.dart';
import 'package:campus_mart/Screens/SignUpScreen/SignUpScreen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width*.1),
        child: SingleChildScrollView(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: kToolbarHeight*2,),

            const Text("Login", style: TextStyle(fontSize:23,fontWeight:FontWeight.bold)),
            Container(height: 10,),
            const Text("Please sign in to continue", style: TextStyle(fontSize:16)),

            Container(height: 30,),

            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                hintText: "Email Address"
              ),
            ),

            Container(height: 20,),

            TextFormField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Password"
              ),
            ),

             Consumer<AuthProvider>(
            builder: (context, provider, child) {

            return !provider.isLoading  ? GestureDetector(
                        onTap: () {
                          provider.loginUser(email.text, password.text);
                        },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                padding: const EdgeInsets.all(20),
                width: size.width,
                decoration:  BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [
                        primary,
                        secondary,
                      ],
                    ),
                  color: primary,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Text("Login", textAlign: TextAlign.center, style: TextStyle(color:Colors.white, fontSize:17))
                ),
                ): const Center(
                    child: CircularProgressIndicator(),
                );
              },
            ),

            Wrap(
              children: [
                  const Text("Forgot password, ", style: TextStyle(fontSize:15,fontWeight:FontWeight.normal)),
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_)=> const ForgotPasswordScreen())
                        );
                      },
                      child: const Text("Click here", style: TextStyle(fontSize:15, color: Colors.orangeAccent, fontWeight:FontWeight.normal))),
              ],
            ),

            Container(height: size.height*.2,),

            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const SignUpScreen())),
                    child: const Text("Sign Up", style: TextStyle(color: primary),)
                  )
                ],
              ),
            )

          ],
        )),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    super.dispose();
  }


  // void loginUser() async{
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await auth.loginUser({"email": email.text.toString(), "password": password.text.toString()})
  //       .then((AuthModel value){
  //         setState(()=> isLoading = false);
  //         context.read<UserProvider>().setUserDetails(UserModel.fromJson(value.data!.toJson()), password.text);
  //         Provider.of<AuthProvider>(context, listen: false).loginUser(value.data!.email!, password.text, context);
  //         OneSignal.shared.setExternalUserId(value.data!.id!);
  //         authProvider?.accessToken = value.auth!;
  //         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const HomeScreen()));
  //   }).catchError((onError){
  //     setState(()=> isLoading = false);
  //     ErrorModel error = ErrorModel.fromJson(jsonDecode(onError));
  //     showMessageError(error.message);
  //   });
  // }

}
