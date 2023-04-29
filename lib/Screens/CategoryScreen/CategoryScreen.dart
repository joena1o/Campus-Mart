import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Screens/CategoryScreen/Widget/ListItemView.dart';
import 'package:campus_mart/Screens/CategoryScreen/Widget/Navbar.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/AdGrid/AdGrid.dart';
import 'package:campus_mart/Utils/Categories.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key, this.val, this.index}) : super(key: key);

  final val;
  final index;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  bool isgrid = true;
  int current = 0;

  @override
  void initState(){
    super.initState();
    setState(()=> current = widget.index);
    context.read<ProductProvider>().getProduct(categories[current], 2, context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const Drawer(),
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: kToolbarHeight-20,),
            const Navbar(),
        Container(
          margin: const EdgeInsets.only(top: 0),
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                width: size.width,
                height: 60,
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    return Container(
                        margin: const EdgeInsets.only(right: 20,top: 10),
                        child: GestureDetector(
                            onTap: (){
                              setState(()=> current = i);
                            },
                            child:chip(categories[i], i))

                    );
                  },
                ),
              )
            ],
          ),
        ),
            Container(height: 20,),
            AdGrid(category: categories[current], grid: 2,)
          ],
        ),
      ),
    );
  }

  Widget chip(String item, int i){
    return Container(
        decoration: BoxDecoration(
            border: (i==current) ? Border.all(color: Colors.transparent):  Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10),
          color: (i==current) ?  const Color(0xFFECECEC) : Colors.transparent
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
