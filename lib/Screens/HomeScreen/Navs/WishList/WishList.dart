import 'package:campus_mart/Screens/HomeScreen/Navs/WishList/Widget/AdGrid.dart';
import 'package:flutter/material.dart';

import '../Homepage/Widget/Navbar/Navbar.dart';

class WishListt extends StatefulWidget {
  const WishListt({Key? key}) : super(key: key);

  @override
  State<WishListt> createState() => _WishListtState();
}

class _WishListtState extends State<WishListt> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.only(left: 5),
            child: const Text(
              "WishList",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )),
        Container(height: 20,),
        const WishListAdGrid()

        // ListItemView()
      ],
    );
  }
}
