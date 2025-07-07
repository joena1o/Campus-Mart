import 'package:campus_mart/screens/home_screen/navs/wish_list/widget/ad_grid.dart';
import 'package:flutter/material.dart';

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
