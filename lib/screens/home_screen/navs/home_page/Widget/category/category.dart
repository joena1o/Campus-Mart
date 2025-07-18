import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/screens/all_category_screen/all_category_screen.dart';
import 'package:campus_mart/screens/category_screen/category_screen.dart';
import 'package:campus_mart/Utils/categories.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  var icons = [
    FontAwesomeIcons.houseChimney,
    FontAwesomeIcons.laptopCode,
    FontAwesomeIcons.shirt,
    FontAwesomeIcons.ticket,
    FontAwesomeIcons.kitchenSet,
    FontAwesomeIcons.personChalkboard,
    FontAwesomeIcons.toolbox
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 const Text("Select category", style: TextStyle(fontSize: 16,  fontWeight: FontWeight.w600),),
                 GestureDetector(
                     onTap: (){
                       Navigator.of(context).push(
                         MaterialPageRoute(builder: (_)=> const AllCategoryScreen())
                       );
                     },
                     child: const Text("View all", style: TextStyle(fontSize: 15, color: primary, fontWeight: FontWeight.normal),)),
              ],
            ),
          ),

          SizedBox(
            width: size.width,
            height: 60,
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) {
                return Container(
                  margin: const EdgeInsets.only(left: 13,top: 9, right: 5),
                  child: GestureDetector(
                      onTap: (){
                        context.read<ProductProvider>().resetItems();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_)=> CategoryScreen(index: i,))
                        );
                      },
                      child:chip(categories[i], i))

                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget chip(String item, int i){
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: DefaultSelectionStyle.defaultColor),
            borderRadius: BorderRadius.circular(10)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child:  Row(
          children: [
            FaIcon(icons[i], size: 15,),
            Container(width: 10,),
            Text(item, style: const TextStyle(fontSize: 13),)
          ],
        ));
  }
}
