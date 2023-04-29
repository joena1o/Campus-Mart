import 'package:flutter/material.dart';

class ReviewArea extends StatefulWidget {
  const ReviewArea({Key? key}) : super(key: key);

  @override
  State<ReviewArea> createState() => _ReviewAreaState();
}

class _ReviewAreaState extends State<ReviewArea> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext ctx, i){
          return Container(
            width: size.width,
            child: Row(
              children: [
                  Container(
                    width: size.width*.1,
                    height: size.width*.1,
                    child: Text("HJ"),
                  )
              ],
            ),
          );
        },

    );
  }
}
