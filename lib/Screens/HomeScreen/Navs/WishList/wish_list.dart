import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/WishList/Widget/AdGrid.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../Homepage/Widget/Navbar/navbar.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.only(left: 20),
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
