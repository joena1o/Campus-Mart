import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/message_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/basic.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/model/message_model.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/screens/home_screen/widgets/ImageWidget/image_widget.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.user, required this.chats}) : super(key: key);

  final UserModel user;
  final List<Chat> chats;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String? user;

  @override
  void initState() {
    super.initState();

    Provider.of<MessageProvider>(context, listen: false).loadChats(widget.chats);

    Provider.of<MessageProvider>(context, listen: false).setAsRead(
        context.read<UserProvider>().userDetails?.id,
        context.read<AuthProvider>().accessToken
    );

    user = context.read<UserProvider>().userDetails?.id;

    context.read<MessageProvider>().checkUserStatus(widget.user.id);

    context.read<MessageProvider>().makeAsReadLocally();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false).scrollToBottom();
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          toolbarHeight: 70,
          leadingWidth: 50,
          leading: const Icon(
            Icons.arrow_back
          ),
          title: Row(
            children: [
              widget.user.image == null ?  CircleAvatar(
                radius: 20,
                child: Text(getInitials("${widget.user.firstName} ${widget.user.lastName}"),style: const TextStyle(fontSize: 14),),
              ): ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ImageWidget(url: widget.user.image!),
                ),
              ),
              Container(width: 10,),
              Expanded(
                child: Consumer<MessageProvider>(
                  builder: (context, provider, child) {
                  return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text("${widget.user.firstName} ${widget.user.lastName}", overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14),),
                    const SizedBox(height: 5,),
                    Text(provider.userIsOnline ? "online" : 'offline', style: const TextStyle(fontSize: 12))
                  ],
                );
                },
              ),
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
          child: Consumer<MessageProvider>(
            builder: (context, provider, child) {
            return Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView.builder(
                  controller: provider.scrollController,
                  itemCount: provider.chats.length,
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  itemBuilder: (BuildContext ctx, i){
                    // print(provider.chats[i].userId == user);
                    return Align(
                      alignment: provider.chats[i].userId == user ? Alignment.centerRight : Alignment.centerLeft,
                      child: BubbleNormal(
                        text: provider.chats[i].message,
                        isSender: provider.chats[i].userId == user,
                        tail: !(provider.chats[i].userId == user),
                        sent: provider.chats[i].userId == user,
                        seen: provider.chats[i].userId == user && provider.chats[i].seen,
                        color: provider.chats[i].userId == user ? Colors.black87 : primary,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),

              Consumer<MessageProvider>(
                builder: (context, provider, child) {
                  return Container(
                width: size.width,
                height: size.height*.09,
                padding:  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Expanded(child:TextFormField(
                     enabled: !provider.sendingMessages,
                    controller: provider.messageText,
                    decoration: const InputDecoration(
                        hintText: 'Type message here..',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none
                        ),
                      ),
                    ),

                    const Icon(Icons.photo_camera),

                    const SizedBox(width: 30),

                    !provider.sendingMessages ? GestureDetector(
                        onTap: (){
                            Provider.of<MessageProvider>(context, listen: false).addMessage(
                              {
                                "userId": context.read<UserProvider>().userDetails?.id,
                                "receiverId": widget.user.id,
                                "type":"text",
                                "kind": 'message',
                                "message": provider.messageText.text.toString()
                              },
                                context.read<AuthProvider>().accessToken
                            );
                        },
                        child: const Icon(Icons.send)
                        ): const Icon(Icons.send, color: Colors.grey,),



                  ],
                    ),
                  );
                },
              ),

            ],
          );
  },
    )
    ),
    );
  }
}
