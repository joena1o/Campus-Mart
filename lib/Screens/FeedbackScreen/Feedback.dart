import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Feedback",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
      ),
    );
  }
}
