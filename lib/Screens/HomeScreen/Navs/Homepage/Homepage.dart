import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/AdGrid/AdGrid.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/Category/Category.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SearchBar(),
        Category(),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 17),
          child: Text(
            "Recent Ads",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        AdGrid(grid: 1, category: "",)
      ],
    );
  }
}
