import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const CircleAvatar(
                child: Text("HJ"),
              ),
              Container(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Hyefur Jonathan", style: TextStyle(fontSize: 14),),
                  Text("online", style: TextStyle(fontSize: 12))
                ],
              )
            ],
          ),
          actions: [
            IconButton(onPressed: (){

            }, icon: const Icon(Icons.phone)),
            const SizedBox(width: 15,)
          ],
        ),
        body:SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Container(
                width: size.width,
                height: size.height*.08,
                padding:  EdgeInsets.symmetric(horizontal: size.width*.05, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child:Padding(
                      padding: const EdgeInsets.only(top:7),
                      child:TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Type message here..',
                          hintStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.photo_camera)
                  ],
                ),
              ),
              Container(
                height: 20,
              )
            ],
          )
    ),
    );
  }
}
