import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  TextEditingController password = TextEditingController();
  TextEditingController confirmedPassword = TextEditingController();

  bool isLoading = false;

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

            const Text("Reset Password", style: TextStyle(fontSize:23,fontWeight:FontWeight.bold)),
            Container(height: 10,),
            const Text("Please enter your new password", style: TextStyle(fontSize:16)),

            Container(height: 30,),

            TextFormField(
              obscureText: true,
              controller: password,
              decoration: const InputDecoration(
                  hintText: "Password"
              ),
            ),

            Container(height: 20,),

            TextFormField(
              controller: confirmedPassword,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "Confirm Password"
              ),
            ),


      Consumer<AuthProvider>(
        builder: (_, bar, __) {
        return !bar.isLoading ? GestureDetector(
              onTap: (){

                if(password.text != confirmedPassword.text){
                  showMessage("Passwords do not match");
                }else{
                  Provider.of<AuthProvider>(context, listen: false).resetPassword(password.text, context);
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
                  child: const Text("Reset", textAlign: TextAlign.center, style: TextStyle(color:Colors.white, fontSize:17))
              ),
            ): Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
            }
          ),

            Container(height: size.height*.2,),


          ],
        )),
      ),
    );
  }
}
