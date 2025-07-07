import 'package:campus_mart/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {

    final userDetails = context.read<UserProvider>().userDetails;

    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text("Hello ${userDetails?.firstName}!", style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold
          ),)),

          Container(height: 10,),

          Row(
            children: [
              const Icon(Icons.location_on),
              Container(width: 5,),
              Text("${userDetails?.campus}", style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.normal
              ),),
            ],
          ),

          Container(height: 20,),

        ],
      )



    );
  }
}
