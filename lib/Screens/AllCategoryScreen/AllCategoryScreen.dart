import 'package:campus_mart/Screens/CategoryScreen/CategoryScreen.dart';
import 'package:campus_mart/Utils/Categories.dart';
import 'package:flutter/material.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemBuilder: (BuildContext ctx, i){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_)=>  CategoryScreen(index: i,))
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: .7),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 100,
                            height: 100,
                            child: Icon(icons[i], size: 30, color: Colors.orangeAccent,),
                          ),
                          Text(categories[i], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ),
                  );
            }),
          ),
        ),
    );
  }
}
