import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  bool isLoading = false;
  TextEditingController email = TextEditingController();

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

            const Text("Request OTP", style: TextStyle(fontSize:23,fontWeight:FontWeight.bold)),
            Container(height: 10,),
            const Text("Please your email address to send otp", style: TextStyle(fontSize:16)),

            Container(height: 30,),

            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                  hintText: "Email Address"
              ),
            ),

                  Consumer<AuthProvider>(
                  builder: (_, bar, __) {
                  return
                  !bar.isLoading ? GestureDetector(
                      onTap: (){
                        if(email.text.isNotEmpty){
                          Provider.of<AuthProvider>(context, listen: false).requestForgotPassword(email.text, context, null);
                        }else{
                          showMessage("Enter your email address", context);
                        }
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
                          child: const Text("Continue", textAlign: TextAlign.center, style: TextStyle(color:Colors.white, fontSize:17))
                      ),
                    ):   Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ));
                  }),

            Container(height: size.height*.2,),

          ],
        )),
      ),
    );
  }
}
