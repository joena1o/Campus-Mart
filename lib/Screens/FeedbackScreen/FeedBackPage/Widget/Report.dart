import 'package:campus_mart/Utils/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute ;
import 'package:nb_utils/nb_utils.dart';


class Report extends StatefulWidget {
  final String? feedBackType;
  const Report({Key? key, this.feedBackType}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  String? user_id;
  String? token;
  String? refreshToken;

  TextEditingController feed = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DottedBorder(
        color: primary,
        dashPattern: [3, 3, 3],
        strokeWidth: 1,
        child: Container(
          width: size.width * .8,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Report an issue with the App", style: TextStyle(fontWeight: FontWeight.w500),),
              10.height,
              const Text(
                  "Please include the Transaction Reference Number in your description.", style: TextStyle(fontSize: 12, color:Colors.grey),),
              20.height,
              Container(
                  height: size.height*.25,
                  decoration:
                      BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Color.fromRGBO(1, 1, 1, 0.1))),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: feed,
                    maxLines: 4,
                    decoration: const InputDecoration(
                        hintText: "Report issue here",
                        hintStyle: TextStyle(fontSize: 12),
                        border: InputBorder.none),
                  )),
              30.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 GestureDetector(
                    onTap: (){

                    },
                    child:Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primary,
                    ),

                    child: const Text("submit", style: TextStyle(color: Colors.white),
                    ),
                  )),
                ],
              )
            ],
          ),
        )

    );
  }
}
