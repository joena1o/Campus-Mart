import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/AdGrid/AdGrid.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/Category/category.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/SearchBar/SearchBar.dart';
import 'package:flutter/material.dart';

class HomepageNav extends StatefulWidget {
  const HomepageNav({Key? key}) : super(key: key);

  @override
  State<HomepageNav> createState() => _HomepageNavState();
}

class _HomepageNavState extends State<HomepageNav> {

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child:  SearchBarWidget(),
        ),
         Category(),
          Padding(
          padding: EdgeInsets.only(top: 20, bottom: 17, left: 15),
          child: Text(
            "Recent Ads",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
         AdGrid(grid: 1, category: "")
      ],
    );
  }
}
