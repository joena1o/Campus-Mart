import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Consumer<ProductProvider>(
          builder: (context, provider, child) {
          return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [

            const Spacer(),

            //  Visibility(
            //    visible: !provider.processingPayment && !provider.processingPaymentFailed,
            //    child: SizedBox(
            //     width: size.width*.5,
            //     height: size.width*.5,
            //     child: Lottie.asset('assets/Lottie/success.json', repeat: false),
            //   ),
            //  ),
            //
            // Visibility(
            //   visible: provider.processingPayment && !provider.processingPaymentFailed,
            //   child:
            //   Container(
            //     margin: const EdgeInsets.only(bottom: 20),
            //     width: size.width*.25,
            //     height: size.width*.25,
            //     child: const CircularProgressIndicator(strokeWidth: 5,)
            //   ),
            // ),
            //
            // Visibility(
            //   visible: !provider.processingPayment && provider.processingPaymentFailed,
            //   child: SizedBox(
            //       width: size.width*.5,
            //       height: size.width*.5,
            //       child: Lottie.asset('assets/Lottie/error_dialog.json', repeat: false),
            //   ),
            // ),
            //
            // const SizedBox(height: 20,),
            //
            // Visibility(
            //     visible: !provider.processingPayment && !provider.processingPaymentFailed,
            //     child: const Padding(
            //       padding:  EdgeInsets.all(15.0),
            //       child:  Text("Your Ad was uploaded Successfully", style: TextStyle(fontSize: 18),),
            //     )),
            //
            // Visibility(
            //     visible: provider.processingPayment && !provider.processingPaymentFailed,
            //     child: const Padding(
            //       padding: EdgeInsets.all(15.0),
            //       child: Text("Please wait, while processing", style: TextStyle(fontSize: 18),),
            //     )),
            //
            // Visibility(
            //     visible: !provider.processingPayment && provider.processingPaymentFailed,
            //     child: const Padding(
            //       padding: EdgeInsets.all(15.0),
            //       child:  Text("Error occured while processing your request", style: TextStyle(fontSize: 18),))),
            //
            //
            // const Spacer(),

              GestureDetector(child:Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10)
                ),
                width: size.width*.8,
                child: const Text("Continue", style: TextStyle(color:Colors.white),),
              ), onTap: (){
                Navigator.pop(context);
              },)

              ],
            );
          },
        ),
      ),
    );
  }
}
