import 'package:campus_mart/Utils/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';


class FeedbackCard extends StatelessWidget {
  const FeedbackCard({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        color: primary,
        dashPattern: [3,3,3],
        strokeWidth: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * .8,
            child: Text("$title", style: const TextStyle(fontWeight: FontWeight.w600),)));
  }
}
