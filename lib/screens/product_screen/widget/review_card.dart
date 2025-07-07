import 'package:campus_mart/model/review_model.dart';
import 'package:campus_mart/screens/home_screen/widgets/ImageWidget/image_widget.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({Key? key, required this.data}) : super(key: key);

  final Datum data;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      width: size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
                  Row(
                    children:  [

                      Visibility(
                        visible: data.user![0].image == null,
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey,
                          child:  Icon(Icons.person, size: 15, color: Colors.black,),
                        ),
                      ),


                      Visibility(
                        visible: data.user![0].image != null,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: ImageWidget(url: data.user![0].image.toString(),)),
                        ),
                      ),


                      const SizedBox(width: 10,),
                      Text("${data.user![0].firstName} ${data.user![0].lastName}", style: const TextStyle(fontWeight: FontWeight.w600),),
                    ],
                  ),

              Row(
                children:  [
                  Icon(Icons.star, size: 16, color: data.rating!=0 ? Colors.orange:Colors.grey,),
                  const SizedBox(width: 5,),
                  Text("Rating: ${data.rating}")
                ]),


            ],
          ),
          const SizedBox(height: 20,),
          SizedBox(
              width: size.width,
              child:  Text("${data.review}", style: const TextStyle(
                color: Colors.grey
              ),)),

          const SizedBox(height: 10,),
          const Divider()
        ],
      ),
    );
  }
}
