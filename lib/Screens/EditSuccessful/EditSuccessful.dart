import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class EditSuccessful extends StatefulWidget {
  const EditSuccessful({Key? key}) : super(key: key);

  @override
  State<EditSuccessful> createState() => _EditSuccessfulState();
}

class _EditSuccessfulState extends State<EditSuccessful> {
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

                SizedBox(
                  width: size.width*.5,
                  height: size.width*.5,
                  child: Lottie.asset('assets/Lottie/success.json', repeat: false),
                ),

                const SizedBox(height: 20,),

                const Text("Your Ad was updated Successfully", style: TextStyle(fontSize: 18),),

                const Spacer(),

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

                  Provider.of<ProductProvider>(context, listen: false).resetMyAdsItems();
                  Provider.of<ProductProvider>(context, listen: false).getMyAds(
                      context.read<UserProvider>().userDetails?.id, context.read<AuthProvider>().accessToken
                  );
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
