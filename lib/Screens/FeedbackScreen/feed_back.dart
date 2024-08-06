import 'package:campus_mart/Screens/FeedbackScreen/FeedBackPage/feed_back_page.dart';
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
        title: const Text(
          "Feedback",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0,
      ),
      body: const FeedbackView(type: '',),
    );
  }
}
