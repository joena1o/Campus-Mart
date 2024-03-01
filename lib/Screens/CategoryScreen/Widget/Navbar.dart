import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.keyboard_arrow_left, size: 35,)),

           Expanded(child:SizedBox(
              child: TextField(
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search here",
                hintStyle: TextStyle(fontSize: 14),
            ),
             onSubmitted: (String? text){
               Provider.of<ProductProvider>(context, listen: false).searchProduct(text,
                   context.read<AuthProvider>().accessToken, context);
             },
          ))),

        ],
      ),
    );
  }
}
