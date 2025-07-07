import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';

class EmptyAlertScreen extends StatefulWidget {
  const EmptyAlertScreen({Key? key}) : super(key: key);

  @override
  State<EmptyAlertScreen> createState() => _EmptyAlertScreenState();
}

class _EmptyAlertScreenState extends State<EmptyAlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text("No Ad Alert")),

          Container(
              margin: const EdgeInsets.only(top: 20),
              decoration:  BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(30)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text("Create Ad Alert", style: TextStyle(color:Colors.white),))


        ]
    );
  }
}
