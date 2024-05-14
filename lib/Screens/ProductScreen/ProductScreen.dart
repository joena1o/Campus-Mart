import 'dart:convert';
import 'package:campus_mart/Model/ErrorModel.dart';
import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/UserModel.dart';
import 'package:campus_mart/Network/ProductClass/ProductClass.dart';
import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Screens/HomeScreen/Widgets/ImageWidget/ImageWidget.dart';
import 'package:campus_mart/Screens/ProductScreen/Widget/ProductBottomNav.dart';
import 'package:campus_mart/Screens/ProductScreen/Widget/ReviewCard.dart';
import 'package:campus_mart/Utils/snackBar.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  UserModel? user;
  String? accessToken;
  ProductClass productClass = ProductClass();

  TextEditingController review = TextEditingController();
  double? ratingValue;

  bool isLoading = false;


  ProductModel? product;

  @override
  void initState(){
    super.initState();
    user = context.read<UserProvider>().userDetails;
    product = widget.product;
    accessToken = context.read<AuthProvider>().accessToken;
    context.read<ProductProvider>().getUserReviews(product?.userId, accessToken);
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
              flexibleSpace:  FlexibleSpaceBar(
                  centerTitle: true,
                  background: product!.images!.isEmpty ? const Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Camera.jpeg')
                    ,): ImageWidget(url: product.images![0]['url'].toString()),
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

              Container(height: 40,),


              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Consumer<ProductProvider>(
                  builder: (_, bar, __) {
                    List<String> images = product.images!.map((e) => e['url'].toString()).toList();
                    return product.images!.isNotEmpty ? SingleChildScrollView(
                        child: GalleryImage(
                          // key: _key,
                          imageUrls: images,
                          numOfShowImages: images.length,
                          //titleGallery: "Images",
                        )
                    ): const Center(
                        child: Text("No Images", style: TextStyle(fontSize: 14),),
                      ); })),


              Container(height: 30,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: size.width,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  const Text("Reviews", style: TextStyle(fontSize: 16),),
                  Row(
                    children:  [

                      // const Icon(Icons.sort),
                      // const SizedBox(width: 10,),

                      IconButton(
                          onPressed: (){
                            customBottomSheet(context);
                          },
                          icon: const Icon(Icons.add, size: 32,))
                    ],
                  )

                ],
              ),),

         Consumer<ProductProvider>(
            builder: (_, data, __) {
              var length = data.reviews;
              return
                !data.getLoadingReviews ? Column(
                children: List.generate(length == null ? 0 : length.data!.length, (index) =>
                  ReviewCard(data: length!.data![index])
                ),
              ):Container(
                margin: const EdgeInsets.only(top: 30),
                child: const Center(
                    child: CircularProgressIndicator()),
              );}),
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
    productClass.addToWishlist({"username":user?.username, "productId": product?.id}, accessToken).then((value){
      showMessage(value['message'], context);
    }).catchError((onError){
      ErrorModel error = ErrorModel.fromJson(jsonDecode(onError));
      showMessage(error.message, context);
    });
  }

  void _onRefresh() async{
    context.read<ProductProvider>().getUserReviews(product?.userId, accessToken);
  }

  void customBottomSheet(BuildContext context) {
    final userDetails = context.read<UserProvider>().userDetails;
    Size size = MediaQuery.of(context).size;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Container(
          height: size.height*.86,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: radiusCircular(20), topRight: radiusCircular(20)),
            color: Colors.white, // Customize the background color
          ),// Set the desired height of the bottom sheet

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10,),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: (){

                  },
                  icon: const Icon(Icons.close),
                ),
              ),

              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child:TextFormField(
                    controller: review,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        hintText: "Type review here"
                    ),
                  )),

              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text("Rating")
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(()=> ratingValue = rating);
                  },
                ),
              ),

              !isLoading ? GestureDetector(
                  onTap: (){
                    if(review.text.isNotEmpty){
                      setState(()=> isLoading = true);
                      productClass.addReview({
                        "user": userDetails?.username, "userId": product?.userId,
                        "ProductId": product?.id, "Review": review.text.toString(),
                        "reviewerId": userDetails?.id,
                        "Rating": ratingValue ?? 0
                      }, accessToken).then((value){
                        setState(()=> isLoading = false);
                        Navigator.of(context).pop();
                        showMessage("Review submitted", context);
                        context.read<ProductProvider>().getUserReviews(product?.userId, accessToken);
                      }).catchError((onError){
                        setState(()=> isLoading = false);
                        ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
                        showMessageError(errorModel.message, context);
                      });
                    }
                  },
                  child:Container(
                      width: size.width,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.orange
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: const Text("Submit", style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w500),)
                  )):Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20),
                child: const CircularProgressIndicator(),)


            ],
          ),
        );
      },
    );
  }

}
