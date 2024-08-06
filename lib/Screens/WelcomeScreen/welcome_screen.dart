import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final loadingUser = context.watch<AuthProvider>().isLoading;

    return Scaffold(
        body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            primary,
            secondary,
          ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:  [
          const Image(
            image: AssetImage(
              "assets/logo.png",
            ),
            width: 50,
            height: 50,
          ),

        Consumer<AuthProvider>(
        builder: (_, bar, __) {
          return Visibility(
            visible: bar.isLoading,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
             ),
            );
          }
        )

        ],
      ),
    ));
  }
}
