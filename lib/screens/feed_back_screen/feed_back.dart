import 'package:campus_mart/screens/feed_back_screen/feed_back_page/feed_back_page.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
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
