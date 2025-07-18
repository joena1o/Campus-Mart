import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/feed_back_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class Bug extends StatefulWidget {
  final String? feedBackType;
  const Bug({Key? key, this.feedBackType}) : super(key: key);

  @override
  State<Bug> createState() => _BugState();
}

class _BugState extends State<Bug> {

  String? token;
  String? refreshToken;

  String feedback = "";

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
                const SizedBox(height: 7,),
                const Text(
                  "Report an issue encountered while using the app", style: TextStyle(fontSize: 12, color:Colors.grey),),
                const SizedBox(height: 7,),
                Container(
                    height: size.height*.25,
                    decoration:
                    BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color.fromRGBO(1, 1, 1, 0.1))),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      style: const TextStyle(fontSize: 12),
                      onChanged: (e){
                        setState(()=> feedback = e);
                      },
                      decoration: const InputDecoration(
                          hintText: "Report bug here",
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none),
                    )),
                const SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<FeedbackProvider>(
                      builder: (context, provider, child) {
                        return !provider.uploadingFeedback
                            ? GestureDetector(
                            onTap: () {
                              if (feedback.isEmpty) {
                                return;
                              }
                              Provider.of<FeedbackProvider>(context,
                                  listen: false)
                                  .uploadFeedback(
                                  context
                                      .read<AuthProvider>()
                                      .accessToken,
                                  {
                                    "userId": context
                                        .read<UserProvider>()
                                        .userDetails
                                        ?.id,
                                    "type": "bug",
                                    "message": feedback.toString()
                                  },
                                  context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: feedback == "" ? Colors.grey : primary,
                              ),
                              child: const Text(
                                "submit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                            : const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          )

      );
    }


}
