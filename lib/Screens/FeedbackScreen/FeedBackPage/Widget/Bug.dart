import 'dart:convert';
import 'package:campus_mart/Utils/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';



class Bug extends StatefulWidget {
  final String? feedBackType;
  const Bug({Key? key, this.feedBackType}) : super(key: key);

  @override
  State<Bug> createState() => _BugState();
}

class _BugState extends State<Bug> {

  String? user_id;
  String? token;
  String? refreshToken;

  TextEditingController feed = TextEditingController();

    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return DottedBorder(
          color: primary,
          dashPattern: const [3, 3, 3],
          strokeWidth: 1,
          child: Container(
            width: size.width * .8,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Report a bug", style: TextStyle(fontWeight: FontWeight.w500),),
                10.height,
                const Text(
                  "Report an issue encountered while using the app", style: TextStyle(fontSize: 12, color:Colors.grey),),
                20.height,
                Container(
                    height: size.height*.25,
                    decoration:
                    BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color.fromRGBO(1, 1, 1, 0.1))),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: feed,
                      decoration: const InputDecoration(
                          hintText: "Report bug here",
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none),
                    )),
                30.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      GestureDetector(
                        onTap: (){
                          if(feed.text.isNotEmpty){

                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: primary,
                          ),
                          child: const Text(
                            "submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                  ],
                )
              ],
            ),
          )

      );
    }


}
