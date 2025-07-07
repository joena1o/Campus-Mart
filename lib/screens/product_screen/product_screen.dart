import 'dart:convert';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/ads_ad_unit.dart';
import 'package:campus_mart/Utils/snackbars.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/model/error_model.dart';
import 'package:campus_mart/model/product_model.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/network/product_class/product_class.dart';
import 'package:campus_mart/screens/home_screen/widgets/ImageWidget/image_widget.dart';
import 'package:campus_mart/screens/product_screen/widget/product_bottom_nav.dart';
import 'package:campus_mart/screens/product_screen/widget/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  BannerAd? _bannerAd;
  BannerAd? _bannerAd2;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  UserModel? user;
  String? accessToken;
  ProductClass productClass = ProductClass();

  TextEditingController review = TextEditingController();
  double? ratingValue;

  bool isLoading = false;

  late ProductModel product;

  @override
  void initState(){
    super.initState();
    user = context.read<UserProvider>().userDetails;
    product = widget.product;
    accessToken = context.read<AuthProvider>().accessToken;
    context.read<ProductProvider>().getUserReviews(product.userId, accessToken);
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: size.height*.5,
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
                }, icon: product.wishList!.isEmpty ? const Icon(Icons.favorite_outline, size: 25,)
                    :  const Icon(Icons.favorite, size: 25,)
                    ))
              ],
              flexibleSpace:  FlexibleSpaceBar(
                  centerTitle: true,
                  background: product.images!.isEmpty ? const Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Camera.jpeg')
                    ,): ImageWidget(url: product.images![0]['url'].toString()),
            ),
            )];
        },
        body: ListView(
          padding:  const EdgeInsets.only(top: 30),
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child:  Text("${product.title}", style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),),
            ),

            5.height,

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Text("${product.adCategory}", style: const TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w600),),
            ),

            5.height,

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child:  Text("${product.description}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal) ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text("Condition: ${product.condition}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal) ),
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

            _bannerAd == null
            // Nothing to render yet.
                ? const SizedBox() : SizedBox(
                height: 50,
                child: AdWidget(
                    ad: _bannerAd!)),

            Container(height: 20,),

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
              !data.isLoadingReviews ? Column(
              children: List.generate(length == null ? 0 : length.data!.length, (index) =>
                ReviewCard(data: length!.data![index])
              ),
            ):Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Center(
                  child: CircularProgressIndicator()),
            );}),

            Container(height: 20,),

            _bannerAd2 == null
            // Nothing to render yet.
                ? const SizedBox() : SizedBox(
                height: 50,
                child: AdWidget(
                    ad: _bannerAd2!)),

          ],
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child:  ProductBottomNav(product: product,),
      ),
    );
}

  addWishList(){
    productClass.addToWishlist({"username":user?.username, "productId": product.id}, accessToken).then((value){
      showMessage(value['message']);
    }).catchError((onError){
      ErrorModel error = ErrorModel.fromJson(jsonDecode(onError));
      showMessage(error.message);
    });
  }


  void customBottomSheet(BuildContext context) {
    final userDetails = context.read<UserProvider>().userDetails;

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
            // Customize the background color
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
                        "user": userDetails?.username, "userId": product.userId,
                        "ProductId": product.id, "Review": review.text.toString(),
                        "reviewerId": userDetails?.id,
                        "Rating": ratingValue ?? 0
                      }, accessToken).then((value){
                        setState(()=> isLoading = false);
                        closeView();
                        showMessage("Review submitted");
                        fetchReviews();
                      }).catchError((onError){
                        setState(()=> isLoading = false);
                        ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError));
                        showMessageError(errorModel.message);
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

  void closeView(){
    Navigator.of(context).pop;
  }

  void fetchReviews(){
    context.read<ProductProvider>().getUserReviews(product.userId, accessToken);
  }

  void _loadAd() {
    final bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnit,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    final bannerAd2 = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnit,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd2 = ad as BannerAd?;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
    bannerAd2.load();
  }

}
