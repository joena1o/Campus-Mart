import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:campus_mart/screens/sign_up_screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



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
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
                          provider.loginUser(email.text, password.text, false);
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
                  ): Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(color: primary,),
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
    email.dispose();
    password.dispose();
    super.dispose();
  }


}
