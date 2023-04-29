import 'package:campus_mart/Screens/ChatScreen/ChatScreen.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Messages", style: TextStyle(fontSize: 15),),
        elevation: 0,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height*.9,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: size.width*.05, vertical: 20),
            itemCount: 10,
            itemBuilder: (BuildContext ctx, i){
              return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> const ChatScreen())
                    );
                  },
                  child:Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const CircleAvatar(
                     radius: 25,
                        child: Text("HJ",style: TextStyle(fontSize: 14),),
                    ),
                    Container(width: 20,),
                    Expanded(child:SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  const [
                           Text("Jonathan Hyefur", style: TextStyle(fontWeight: FontWeight.w600),),
                          SizedBox(height: 5,),
                           Text("This is where your message is to appear and should very"),
                           SizedBox(height: 10,),
                           Divider()
                        ],
                      ),
                    )),
                    Container(width: 20,),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const Text("12:00"),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            // decoration: BoxDecoration(
                            //   color: primary,
                            //   borderRadius: BorderRadius.circular(100),
                            // ),
                              padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                              child: const Text("2",style: TextStyle(fontSize: 14, color: primary),)),
                        ],
                      ),
                    )
                ],
              )));
            }
        ),
      )
    );
  }
}
