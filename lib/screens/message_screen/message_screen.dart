import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/message_provider.dart';
import 'package:campus_mart/Provider/theme_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/screens/chat_screen/chat_screen.dart';
import 'package:campus_mart/screens/home_screen/Widgets/ImageWidget/ImageWidget.dart';
import 'package:campus_mart/Utils/basic.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/time_and_date.dart';
import 'package:campus_mart/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  
  
  @override
  void initState() {
    super.initState();
    
    Provider.of<MessageProvider>(context, listen: false).getMessages(
        context.read<UserProvider>().userDetails?.id,
        context.read<AuthProvider>().accessToken
    );

  }

  @override
  Widget build(BuildContext context) {

   final userId = context.read<AuthProvider>().authModel.data?.id;
   Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          width: size.width,
          child: Column(
            children: [

              const SizedBox(height: 25,),

              Consumer<ThemeProvider>(
              builder: (context, provider, child) {
              return Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: provider.isDark ? AppColors.darkAccent : AppColors.lightAccent,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, icon: const Icon(Icons.search, size: 25,)),

                    Expanded(child:SizedBox(
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search here",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          onSubmitted: (String? text){

                          },
                        ))),

                  ],
                ),
              );
              },
              ),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25,),
                child: const Text("Messages", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
              ),

              Consumer<MessageProvider>(
                builder: (context, provider, child) {

                return !provider.loadingMessages ? Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    itemCount: provider.messageModel?.length ?? 0,
                    itemBuilder: (BuildContext ctx, i){

                      final user = provider.messageModel![i].user2![0].id == userId ?
                      provider.messageModel![i].user : provider.messageModel![i].user2;

                      final chats = provider.messageModel?[i].chats;

                      return GestureDetector(
                          onTap: (){
                            UserModel chattingWith = UserModel.fromJson(user[0].toJson());
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_)=> ChatScreen(user: chattingWith, chats: chats))
                            );
                          },
                          child:Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             user?[0].image == null ?  CircleAvatar(
                               radius: 25,
                                  child: Text(getInitials("${user?[0].firstName} ${user?[0].lastName}"),style: const TextStyle(fontSize: 14),),
                              ): ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: SizedBox(
                                 width: 50,
                                 height: 50,
                                 child: ImageWidget(url: user![0].image.toString()),
                             ),
                            ),

                            Container(width: 15,),

                            Expanded(child:SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:   [

                                   Text(user![0].firstName.toString(), style: const TextStyle(fontWeight: FontWeight.w600),),

                                  const SizedBox(height: 5,),

                                   Visibility(
                                       visible: chats!.isNotEmpty,
                                       child: Padding(
                                         padding: const EdgeInsets.only(top: 2.0),
                                         child: Text(chats[chats.length-1].message),
                                       )),
                                   const SizedBox(height: 15,),
                                   // Divider()
                                ],
                              ),
                            )),


                            Container(width: 20,),


                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [

                                  Text(getDateDescriptionChat(chats[chats.length-1].updatedAt)),

                                  chats[chats.length-1].userId != context.read<UserProvider>().userDetails?.id ?

                                  Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
                                      child: Visibility(
                                        visible: chats.where((element) => element.seen == false).isNotEmpty,
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: primary,
                                          child: Text(chats.where((element) => element.seen == false).length.toString(),
                                            style: const TextStyle(fontSize: 12, color: Colors.white)
                                          ),
                                        ),
                                      )): Container(
                                          padding:  const EdgeInsets.only(top: 8.0),
                                          child:  const Icon(Icons.check),
                                        ),

                                ],
                              ),
                            )
                        ],
                      )));
                    }
                ),
              ) : const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            ],
          ),
        ),
      )
    );
  }
}
