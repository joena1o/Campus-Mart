import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/model/product_model.dart';
import 'package:campus_mart/model/user_model.dart';
import 'package:campus_mart/screens/edit_ad_screen/edit_ad_screen.dart';
import 'package:campus_mart/Utils/ads_ad_unit.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/screens/home_screen/widgets/ImageWidget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MyAdScreen extends StatefulWidget {
  const MyAdScreen({Key? key}) : super(key: key);
  @override
  State<MyAdScreen> createState() => _MyAdScreenState();
}

class _MyAdScreenState extends State<MyAdScreen> {

  BannerAd? _bannerAd;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    context.read<ProductProvider>().resetMyAdsItems();
    context.read<ProductProvider>().getMyAds(
        context.read<UserProvider>().userDetails!.id,
        context.read<AuthProvider>().accessToken);
    _loadAd();
  }

  void _onLoading() async{
    context.read<ProductProvider>().getMyAds(context.read<UserProvider>().userDetails?.id, context.read<AuthProvider>().accessToken);
  }

  static const images = ['Camera.jpeg'];

  String? selectedId;
  ProductModel? selectedAd;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Ads", style: TextStyle(fontSize: 15),),
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.chevron_left, size: 30,),
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height*.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
         Expanded(
        child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            onLoading: _onLoading,
            controller: context.read<ProductProvider>().refreshController,
            child: Consumer<ProductProvider>(
                builder: (_, bar, __) {
                  return !bar.isGettingMyProduct ?

                   bar.myProductList.isNotEmpty ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: SingleChildScrollView(
                      child: StaggeredGrid.count(
                        crossAxisCount:2,
                        mainAxisSpacing: 10,
                        axisDirection: AxisDirection.down,
                        crossAxisSpacing: 10,
                        children: List.generate(bar.myProductList.toList().length, (index) {
                          UserModel user = UserModel.fromJson(bar.myProductList[index].user![0]);
                          return SizedBox(
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
                                            child: bar.myProductList[index].images!.isEmpty ? Image(image: AssetImage("assets/images/${images[0]}"),
                                              fit: BoxFit.cover,
                                            ):ImageWidget(url: bar.myProductList[index].images![0]['url'].toString()),
                                          ))),

                                      Positioned(
                                        top: 0,
                                        child: Visibility(
                                          visible: bar.myProductList[index].adType != "Free",
                                          child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration:  BoxDecoration(
                                                  color: bar.myProductList[index].adType == "Standard" ? Colors.orangeAccent
                                                      : Colors.green
                                              ),
                                              child: Text("${bar.myProductList[index].adType} Ad",
                                                style: const TextStyle(color: Colors.white, fontSize: 10),
                                              )
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                          right: 0,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(()=> selectedId = bar.myProductList[index].id);
                                                setState(()=> selectedAd = bar.myProductList[index]);
                                                customBottomSheet(context);
                                              },
                                              icon:  const Icon(
                                                Icons.more_horiz,
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
                                        child: Text("${bar.myProductList[index].title}",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Text("${bar.myProductList[index].adCategory}",
                                          style: const TextStyle(color: primary, fontSize: 12)),

                                      Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 7),
                                          child:Text("${user.campus}",
                                              style: const TextStyle(fontSize: 12)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      )
                  )) : const Center(
                     child: Text("No Ads", style: TextStyle(fontSize: 17),),
                   )

                       : const Center(
                    child:  CircularProgressIndicator(),
                  ); })
        )),

            _bannerAd == null
            // Nothing to render yet.
                ? const SizedBox() : SizedBox(
                height: 50,
                child: AdWidget(
                    ad: _bannerAd!)),

          ],
        ),
      ),
    );
  }


  void customBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Container(
          height: size.height*.26 ,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: radiusCircular(20), topRight: radiusCircular(20)),
            color: Colors.white, // Customize the background color
          ),// Set the desired height of the bottom sheet

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> EditAdScreen(product: selectedAd!))
                    );
                  },
                  child: const Row(
                    children:  [
                      Icon(Icons.edit, color: Colors.grey, size: 30,),
                      SizedBox(width: 20,),
                      Text("Edit", style: TextStyle(fontSize: 16),)
                    ],
                  ),
                ),

              const SizedBox(height: 30,),

                GestureDetector(
                    onTap: (){
                      deleteAd();
                    },
                    child: const Row(
                    children:  [
                     Icon(Icons.delete, color: Colors.red, size: 30,),
                    SizedBox(width: 20,),
                    Text("Delete", style: TextStyle(fontSize: 16))
                  ],
                )),


            ],
          ),
        );
      },
    );
  }

  void deleteAd(){
    Navigator.pop(context);
    context.read<ProductProvider>().deleteAd(selectedId,
        context.read<UserProvider>().userDetails?.id,
        context.read<AuthProvider>().accessToken
    );
  }

  void _loadAd() {
    final bannerAd = BannerAd(
      size: AdSize.fullBanner,
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

    // Start loading.
    bannerAd.load();
  }

}
