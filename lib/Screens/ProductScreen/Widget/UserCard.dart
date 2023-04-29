import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: size.width*.15,
              height: size.width*.15,
              color: Colors.black,
            ),
          ),
          Column(
            children: [
              SizedBox(width: size.width*.7,
                child: const Text("Hyefur Jonathan", style: TextStyle(color: primary, fontSize: 16),)
                ,),
              Container(height: 5,),
              SizedBox(width: size.width*.7,
                child: const Text("jonathanhyefur@gmail.com")
                ,)
            ],
          )
        ],
      ),
    );
  }
}
