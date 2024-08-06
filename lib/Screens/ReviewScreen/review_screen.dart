import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Reviews", style: TextStyle(fontSize: 15),),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.chevron_left, size: 30,),
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height*.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: size.height*.83,
              padding: EdgeInsets.symmetric(horizontal:size.width*.05),
              child: ListView(
                children: const [
                  // Text("Hello")
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
