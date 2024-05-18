import 'package:campus_mart/Model/ProductModel.dart';
import 'package:campus_mart/Model/WishProductModel.dart';
import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/UserProvider.dart';
import 'package:campus_mart/Screens/HomeScreen/Widgets/ImageWidget/ImageWidget.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Utils/timeAndDate.dart';
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

  void _onRefresh() async{
    //getProducts();
    print("is working");
  }

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
                child:  StaggeredGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  axisDirection: AxisDirection.down,
                  crossAxisSpacing: 10,
                  children: List.generate(data.wishProductModel!.toList().length, (index) {
                    final products = data.wishProductModel as List<WishProductModel>;
                    return GestureDetector(
                        onTap: (){
                          customBottomSheet(context, products![index]);
                        },
                        child: SizedBox(
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
                                          width: size.width * .5,
                                          height: index%2==0? size.width * .34 : size.width * .4,
                                          child: products![index].product![0].images!.isEmpty ? Image(image: AssetImage("assets/images/${images[0]}"),
                                            fit: BoxFit.cover,
                                          ):ImageWidget(url: products![index].product![0].images![0]['url'].toString()),

                                        ))),

                                    Positioned(
                                      top: 0,
                                      child: Visibility(
                                        visible: products![index].product![0].adType != "Free",
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: products![index].product![0].adType == "Standard" ? Colors.orangeAccent
                                                    : Colors.green
                                            ),
                                            child: Text("${products![index].product![0].adType} Ad",
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
                                      child: Text("${products![index].product![0].title}",
                                        style: const TextStyle(color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                    Text("${products![index].product![0].adCategory}",
                                        style: const TextStyle(color: primary, fontSize: 12)),

                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 7),
                                        child:Text("${products![index].user![0].campus}",
                                            style: const TextStyle(color: Colors.black, fontSize: 12))

                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  }),
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
        return Container(
          height: size.height*.80,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: radiusCircular(20), topRight: radiusCircular(20)),
            color: Colors.white, // Customize the background color
          ),// Set the desired height of the bottom sheet

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: (){
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),


              ListTile(
                style: ListTileStyle.list,
                leading: SizedBox(
                  height: size.width * .65,
                  child: product.product![0].images!.isEmpty ? Image(image: AssetImage("assets/images/${images[0]}"),
                    fit: BoxFit.cover,
                  ):ImageWidget(url: product.product![0].images![0]['url'].toString()),
                ),
                title: Text(product.product![0].title!),
                subtitle: Text(product.product![0].description!),
              ),

              Container(height: 30,),

              Visibility(
                visible: product.product![0].adType != "Free",
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.orangeAccent
                    ),
                    child: Text("${product.product![0].adType} Ad",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    )
                ),
              ),

              Container(height: 30,),

              const Text("Location", style: TextStyle(fontSize: 15, color: primary),),
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

                    GestureDetector(child:Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.messenger_outline,
                        size: 24,
                        color: primary,
                      ),
                    ), onTap: (){
                      launch("sms: ${product.user![0].phone}");
                    },)

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
  }

}
