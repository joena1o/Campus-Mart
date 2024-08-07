import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/WishProductModel.dart';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/theme_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Screens/HomeScreen/Widgets/ImageWidget/ImageWidget.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/time_and_date.dart';
import 'package:campus_mart/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:url_launcher/url_launcher.dart';

class WishListAdGrid extends StatefulWidget {
  const WishListAdGrid({Key? key}) : super(key: key);

  @override
  State<WishListAdGrid> createState() => _WishListAdGridState();
}

class _WishListAdGridState extends State<WishListAdGrid> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  static const images = ['Camera.jpeg'];
  bool isLoading = true;
  List<ProductModel> products = [];

  void _onRefresh() {}

  @override
  void initState(){
    super.initState();
    final user = context.read<UserProvider>().userDetails;
    context.read<ProductProvider>().getWishList(user!.username, context.read<AuthProvider>().accessToken);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
        child:  Consumer<ProductProvider>(builder: (_, data, __) {
          return !data.isLoadingWishList ? SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onRefresh,
            controller: _refreshController,
            child: SingleChildScrollView(
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    axisDirection: AxisDirection.down,
                    crossAxisSpacing: 4,
                    children: List.generate(data.availableItems.length, (index) {
                      final products = data.availableItems;
                      return products[index].product!.isNotEmpty ?
                         GestureDetector(
                            onTap: (){
                              customBottomSheet(context, products[index]);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(
                                    width: size.width * .5,
                                    height: index%2==0? size.width * .34 : size.width * .4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey,
                                    ),
                                    child: Stack(
                                      children: [

                                        Positioned(child: Opacity(
                                            opacity: 0.78,
                                            child: SizedBox(
                                              width: size.width * .65,
                                              height: index%2==0? size.width * .45 : size.width * .45,
                                              child: products[index].product![0].images!.isEmpty ? Image(image: AssetImage("assets/images/${images[0]}"),
                                                fit: BoxFit.cover,
                                              ):ImageWidget(url: products[index].product![0].images![0]['url'].toString()),
                                            ))),

                                        Positioned(
                                          top: 0,
                                          child: Visibility(
                                            visible: products[index].product![0].adType != "Free",
                                            child: Container(
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: products[index].product![0].adType == "Standard" ? Colors.orangeAccent
                                                        : Colors.green
                                                ),
                                                child: Text("${products[index].product![0].adType} Ad",
                                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                                )
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                            right: 0,
                                            child: IconButton(
                                                onPressed: () {},
                                                icon:  const Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                ))),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 7),
                                          child: Text("${products[index].product![0].title}",
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        Text("${products[index].product![0].adCategory}",
                                            style: const TextStyle(color: primary, fontSize: 12)),

                                        Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 7),
                                            child:Text("${products[index].user![0].campus}",
                                                style: const TextStyle(fontSize: 12))

                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )): Container();
                    }),
                              ),
                ))): const Center(
          child: CircularProgressIndicator(),
        ); }));
  }

  void customBottomSheet(BuildContext context, WishProductModel product) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Consumer<ThemeProvider>(
        builder: (context, provider, child) {
        return Container(
          height: size.height*.80,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: provider.isDark ? AppColors.darkBackground : AppColors.lightBackground,
            borderRadius: BorderRadius.only(topLeft: radiusCircular(20), topRight: radiusCircular(20)), // Customize the background color
          ),// Set the desired height of the bottom sheet

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),


               Row(
                children: [

                  SizedBox(
                    width: 100,
                    height: 100,
                    child: product.product![0].images!.isEmpty ? Image(image: AssetImage("assets/images/${images[0]}"),
                      fit: BoxFit.cover,
                    ): ImageWidget(url: product.product![0].images![0]['url'].toString()),
                  ),

                  const SizedBox(width: 20,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.product![0].title!),
                      const SizedBox(width: 10,),
                      Text(product.product![0].description!),
                    ],
                  )


                ],
              ),

              Container(height: 30,),

              Visibility(
                visible: product.product![0].adType != "Free",
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration:  BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(3)
                    ),
                    child: Text("${product.product![0].adType} Ad",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    )
                ),
              ),

              Container(height: 30,),

              const Text("Location", style: TextStyle(fontSize: 15, color: primary),),
              Container(height: 10,),
              Text(product.product![0].campus!),


              Expanded(child: Container()),

              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Consumer<ProductProvider>(
                      builder: (_, bar, __) {
                        List<String> images = product.product![0].images!.map((e) => e['url'].toString()).toList();
                        return product.product![0].images!.isNotEmpty ? SingleChildScrollView(
                            child: GalleryImage(
                              // key: _key,
                              imageUrls: images,
                              numOfShowImages: images.length,
                              //titleGallery: "Images",
                            )
                        ): const Center(
                          child: Text("No Images", style: TextStyle(fontSize: 14),),
                        ); })),


          Expanded(child: Container()),


          Container(
            width: size.width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20))),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child:
                  !product.product![0].contactForPrice! ?
                  Text("N${normalizeAmount(product.product![0].price!)}", style: const TextStyle(fontSize: 23, fontFamily: "century", letterSpacing: 1),)
                      : const Text("Contact for price", style: TextStyle(fontSize: 15, letterSpacing: 1),),
                ),

                Row(
                  children: [

                    GestureDetector(child:Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        // border: Border.all(color: primary),
                          borderRadius: BorderRadius.circular(10)),
                      child: const FaIcon(
                        FontAwesomeIcons.phone,
                        size: 24,
                        color: primary,
                      ),
                    ), onTap: (){
                      launch("tel: ${product.user![0].phone}");
                    },),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: const FaIcon(
                        FontAwesomeIcons.envelope,
                        size: 24,
                        color: primary,
                      ),
                    ),

                    // GestureDetector(child:Container(
                    //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: const Icon(
                    //     Icons.messenger_outline,
                    //     size: 24,
                    //     color: primary,
                    //   ),
                    // ), onTap: (){
                    //   launch("sms: ${product.user![0].phone}");
                    // },)

                  ],
                )

              ],
            ),
          )

            ],
          ),
        );
      },
    );
      },
    );
  }

}
