import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';

class ListItemView extends StatefulWidget {
  const ListItemView({Key? key}) : super(key: key);

  @override
  State<ListItemView> createState() => _ListItemViewState();
}

class _ListItemViewState extends State<ListItemView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(child:SizedBox(
      width: size.width*.89,

      child: ListView.builder(
        padding:  const EdgeInsets.only(top: 20),
        itemCount: 10,
        itemBuilder: (BuildContext ctx, i) {
          return Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.only(bottom:25),
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius:  BorderRadius.circular(5),
                    child: Container(
                      width: size.width * .26,
                      height: size.width * .23,
                      color: Colors.grey,
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        width: size.width * .45,
                        child: const Text("Tecno Spark 5 pro", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14 ),)),
                    SizedBox(width: size.width * .45, child: const Text("Gadgets", style: TextStyle(color: primary),))
                  ],
                ),

                Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Icon(Icons.more_horiz_outlined)),

              ],
            ),
          );
        },
      ),
    ));
  }
}
