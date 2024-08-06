import 'package:campus_mart/Screens/MessageScreen/message_screen.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height*.08,
      margin: EdgeInsets.symmetric(horizontal: size.width*.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: (){
            Scaffold.of(context).openDrawer();
          }, icon: const Icon(Icons.menu, size: 25,)),

          IconButton(onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_)=> const MessageScreen())
            );
          }, icon: const Icon(Icons.messenger_outline, size: 25,))
        ],
      ),
    );
  }
}
