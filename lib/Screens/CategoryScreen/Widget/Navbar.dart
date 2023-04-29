import 'package:campus_mart/Utils/colors.dart';
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
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.chevron_left, size: 25,)),

          const Expanded(child:SizedBox(
              child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search here",
              hintStyle: TextStyle(fontSize: 12)
            ),
          ))),

          IconButton(onPressed: (){
            Scaffold.of(context).openDrawer();
          }, icon: const Icon(Icons.tune, size: 25))
        ],
      ),
    );
  }
}
