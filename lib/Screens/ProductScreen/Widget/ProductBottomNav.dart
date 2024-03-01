import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/timeAndDate.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductBottomNav extends StatefulWidget {
  const ProductBottomNav({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  State<ProductBottomNav> createState() => _ProductBottomNavState();
}

class _ProductBottomNavState extends State<ProductBottomNav> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProductModel product = widget.product;
    UserModel user = UserModel.fromJson(product.user![0]);

    return Container(
      width: size.width,
      height: size.height * .1,
      decoration: const BoxDecoration(

          borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
      padding: EdgeInsets.symmetric(horizontal: size.width * .05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child:
            !product.contactForPrice! ?
            Text("N${normalizeAmount(product.price!)}", style: const TextStyle(fontSize: 23, fontFamily: "century", letterSpacing: 1),)
            : const Text("Contact for price", style: TextStyle(fontSize: 15, letterSpacing: 1),)
            ,
          ),

          Row(
            children: [

              GestureDetector(child:Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  // border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(10)),
                child: const FaIcon(
                  FontAwesomeIcons.phone,
                  size: 24,
                  color: primary,
                ),
              ), onTap: (){
                launch("tel: ${user.phone}");
              },),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  // border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(10)),
                child: const FaIcon(
                  FontAwesomeIcons.envelope,
                  size: 24,
                  color: primary,
                ),
              ),
              GestureDetector(child:Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  // border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.messenger_outline,
                  size: 24,
                  color: primary,
                ),
              ), onTap: (){
                launch("sms: ${user.phone}");
              },)

            ],
          )

        ],
      ),
    );
  }
}
