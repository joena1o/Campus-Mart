import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Screens/CategoryScreen/Widget/Navbar.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/AdGrid/CategoryAdGrid.dart';
import 'package:campus_mart/Utils/categories.dart';
import 'package:campus_mart/Utils/adsAdUnit.dart';
import 'package:campus_mart/Utils/states.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  BannerAd? _bannerAd;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  int currentCategoryItemIndex = 0;

  @override
  void dispose() {
    _bannerAd?.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    if(widget.index != -1){
      currentCategoryItemIndex = widget.index;
      context.read<ProductProvider>().getProduct(removeSpecialCharactersAndSpaces(
          categories[currentCategoryItemIndex]), 2,
          context.read<AuthProvider>().accessToken, refreshControllerLoadComplete);
    }
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Navbar(categoryPage: widget.index!=-1),

              Container(
                margin: const EdgeInsets.only(top: 0),
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Visibility(
                      visible: widget.index!=-1,
                      child: SizedBox(
                        width: size.width,
                        height: 60,
                        child: ListView.builder(
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, i) {
                            return Container(
                                margin: const EdgeInsets.only(right: 20,top: 10),
                                child: GestureDetector(
                                    onTap: (){
                                      setState(()=> currentCategoryItemIndex = i);
                                      context.read<ProductProvider>().resetItems();
                                      context.read<ProductProvider>().getProduct(
                                          removeSpecialCharactersAndSpaces(categories[i]),
                                          2, context.read<AuthProvider>().accessToken, refreshControllerLoadComplete);
                                    },
                                    child: chip(categories[i], i))

                            );
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              Container(height: 10,),

              Container(height: 20,),

              CategoryAdGrid(category: categories[currentCategoryItemIndex], grid: 2,),

              _bannerAd == null
              // Nothing to render yet.
                  ? const SizedBox() : SizedBox(
                  height: 50,
                  child: AdWidget(ad: _bannerAd!)),

            ],
          ),
        ),
      ),
    );
  }

  Widget chip(String item, int i){
    return Container(
        decoration: BoxDecoration(
            border:(i==currentCategoryItemIndex) ? Border.all(color: Colors.orange, width: 1) : Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          color: Colors.transparent
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child:  Row(
          children: [
            FaIcon(icons[i], size: 15, color: (i==currentCategoryItemIndex) ? Colors.orange:Colors.black,),
            Container(width: 10,),
            Text(item, style: TextStyle(fontSize: 13, color: (i==currentCategoryItemIndex) ? Colors.orange:Colors.black,),)
          ],
        ));
  }

  void refreshControllerLoadComplete(){
    _refreshController.loadComplete();
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

    // Start loading.
    bannerAd.load();
  }

}

