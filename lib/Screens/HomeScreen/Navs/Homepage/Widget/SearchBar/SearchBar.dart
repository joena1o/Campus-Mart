import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
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



          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child:Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250, 250, 250, 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text("Search here...", style: TextStyle(fontSize: 12),),
                )),
                Container(width: 10,),
                Container(
                  width: size.width*.15,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          secondary,
                          primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 17,),
                )
              ],
            ),
          )

        ],
      )



    );
  }
}
