import 'dart:async';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

  final TextEditingController _controller = TextEditingController();
  final borderColor = const Color.fromRGBO(23, 171, 144, 0.4);

  bool isLoading = true;
  int timeLeft = 30;

  UserModel? userDetails;

  @override
  void initState() {
    resetOtpTimer();
    userDetails = context.read<UserProvider>().userDetails;
    Provider.of<AuthProvider>(context, listen: false).requestVerifyEmailAddress(
        userDetails!.email!, context);
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primary),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
          color: Colors.white
      ),
    );

    return Scaffold(
        body: Consumer<AuthProvider>(
            builder: (_, bar, __) { return Container(
              padding: EdgeInsets.symmetric(horizontal: size.width*.1),
              child: SingleChildScrollView(child: bar.isLoading ?  Container(
                alignment: Alignment.center,
                width: size.width,
                height: size.height,
                child: const CircularProgressIndicator(
                )) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: kToolbarHeight*2,),

                  const Text("Verify Email Your Address", style: TextStyle(fontSize:23,fontWeight:FontWeight.bold)),

                  Container(height: 10,),

                  const Text("Input the otp code sent to your email address", style: TextStyle(fontSize:16)),

                  Container(height: 30,),


                  Center(
                    child: Pinput(
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      length: 6,
                      controller: _controller,
                      validator: (s) {
                        return null;
                      },
                      onChanged: (value) {
                        // Code to execute when there is a change in the entered values
                      },
                      onCompleted: (value){
                        Provider.of<AuthProvider>(context, listen: false).verifyEmailAddress(value, userDetails!.email!, _timer);
                      },
                    ),
                  ),

                  20.height,

                  !bar.isLoading ?

                  Wrap(
                    children: [
                      const Text("Didn't receive code?", style: TextStyle(fontSize:15,fontWeight:FontWeight.normal)),
                      6.width,
                      GestureDetector(
                          onTap: (){
                            isLoading ? null :
                            Provider.of<AuthProvider>(context, listen: false).requestVerifyEmailAddress(userDetails!.email!, context);

                            isLoading ? null : resetOtpTimer();
                          },
                          child: Text("Click here to resend ( $timeLeft ) secs", style: TextStyle(fontSize:15, color: isLoading ? Colors.grey :  Colors.orangeAccent, fontWeight:FontWeight.normal))),
                    ],
                  )


                      : const Center(
                    child: CircularProgressIndicator(),
                  ),

                  Container(height: size.height*.2,),

                ],
              )),
            ); })
    );
  }

  late Timer _timer;

  resetOtpTimer(){
    setState(()=> timeLeft = 30);
    setState(()=> isLoading = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      if (timeLeft > 0) {
        setState(()=>timeLeft--);
      } else {
        setState((){
          isLoading = false;
          _timer.cancel();
        });
      }
    });
  }
}
