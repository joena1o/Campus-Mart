import 'dart:convert';

import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/ProductClass/ProductClass.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Screens/ProductScreen/Widget/ProductBottomNav.dart';
import 'package:campus_mart/Utils/Snackbar.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  UserModel? user;
  ProductClass productClass = ProductClass();

  ProductModel? product;

  @override
  void initState(){
    super.initState();
    user = context.read<UserProvider>().userDetails;
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProductModel product = widget.product;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: size.height*.5,
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.grey,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              floating: true,
              pinned: true,
              actions: [
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    child:IconButton(onPressed: (){
                      addWishList();
                }, icon: product!.wishList!.isEmpty ? const Icon(Icons.favorite_outline, size: 25,)
                    :  const Icon(Icons.favorite, size: 25,)
                    ))
              ],
              flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: true,
                  background: Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Camera.jpeg'),),
            ),
            )];
        },
        body: Container(
          color: Colors.white,
          child: ListView(
            padding:  const EdgeInsets.only(top: 30),
            children: [

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child:  Text("${product?.title}", style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Text("${product?.adCategory}", style: const TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w600),),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child:  Text("${product?.description}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal) ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text("Condition: ${product?.condition}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal) ),
              ),

              Container(height: 40,),

              const Center(
                child: Text("Images", style: TextStyle(fontSize: 16),),
              ),

              Container(height: 20,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width*.29,
                    height: size.width*.3,
                    color: Colors.black,
                  ),
                  Container(
                    width: size.width*.29,
                    height: size.width*.3,
                    color: Colors.black,
                  ),
                  Container(
                    width: size.width*.29,
                    height: size.width*.3,
                    color: Colors.black,
                  )
                ],
              )),

              Container(height: 30,),

              const Center(
                child: Text("Reviews", style: TextStyle(fontSize: 16),),
              ),



            ],
          ),
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child:  ProductBottomNav(product: product,),
      ),
    );
}

  addWishList(){
    productClass.addToWishlist({"username":user?.username, "productId": product?.id}).then((value){
      showMessage(value['message'], context);
    }).catchError((onError){
      ErrorModel error = ErrorModel.fromJson(jsonDecode(onError));
      showMessage(error.message, context);
    });
  }

}
