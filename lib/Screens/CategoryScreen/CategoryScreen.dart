import 'package:campus_mart/Model/CampusModel.dart';
import 'package:campus_mart/Provider/AuthProvider.dart';
import 'package:campus_mart/Provider/ProductProvider.dart';
import 'package:campus_mart/Provider/SignUpProvider.dart';
import 'package:campus_mart/Screens/CategoryScreen/Widget/Navbar.dart';
import 'package:campus_mart/Screens/HomeScreen/Navs/Homepage/Widget/AdGrid/CategoryAdGrid.dart';
import 'package:campus_mart/Utils/categories.dart';
import 'package:campus_mart/Utils/adsAdUnit.dart';
import 'package:campus_mart/Utils/states.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  BannerAd? _bannerAd;

  bool isgrid = true;
  int current = 0;

  String? state;
  String? campus;


  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    if(widget.index!=-1){
      current = widget.index;
      context.read<ProductProvider>().getProduct(removeSpecialCharactersAndSpaces(
          categories[current]), 2,
          context.read<AuthProvider>().accessToken);
    }
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child:Expanded(
          child: ListView(
            children:  [

              const Text("State"),

              DropdownButton<String>(
                value: state,
                hint:
                SizedBox(width: size.width/1.8, child: const Text("Select State", style: TextStyle(fontSize: 14))),
                icon: const Icon(Icons.keyboard_arrow_down),
                underline: Container(),
                items: states.map((dynamic item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: SizedBox(width: size.width/1.8, child: Text(item, style: const TextStyle(fontSize: 14))),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // setState(()=> state = newValue);
                  // context.read<SignUpProvider>().fetchCampuses(newValue, context);
                },
              ),

              const SizedBox(height: 20,),

              const Text("Campus"),

              Consumer<SignUpProvider>(builder: (_, data, __) { return !data.loadingCampus ? DropdownButton(
                value: campus,
                hint: SizedBox(width: size.width/1.8, child: data.campuses.toList().isEmpty ? const Text("Fetching Campuses",
                style: TextStyle(fontSize: 14),)
                    : const Text("Select Campus", style: TextStyle(fontSize: 14))),
                icon: const Icon(Icons.keyboard_arrow_down),
                underline: Container(),
                items: data.campuses.map((Campus item) {
                  return DropdownMenuItem(
                    value: item.campus,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: size.width/1.8, child: Text(item.campus.toString(), style: const TextStyle(fontSize: 14))),
                  );
                }).toList(),
                onChanged: (dynamic newValue) {
                  // setState(()=> campus = newValue);
                },
              ) : const Center(child:CircularProgressIndicator()); }),


              const SizedBox(height: 20,),

              const Text("Price Range", style: TextStyle(fontSize: 14))


            ],
          ),
        ),
      )),
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: kToolbarHeight-10,),

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
                                    setState(()=> current = i);
                                    //context.read<ProductProvider>().currentCategory = categories[current];
                                    context.read<ProductProvider>().resetItems();
                                    context.read<ProductProvider>().getProduct(
                                        removeSpecialCharactersAndSpaces(categories[i]),
                                        2, context.read<AuthProvider>().accessToken);
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

            CategoryAdGrid(category: categories[current], grid: 2,),

            _bannerAd == null
            // Nothing to render yet.
                ? const SizedBox() : SizedBox(
                height: 50,
                child: AdWidget(ad: _bannerAd!)),

          ],
        ),
      ),
    );
  }

  Widget chip(String item, int i){
    return Container(
        decoration: BoxDecoration(
            border:(i==current) ? Border.all(color: Colors.orange, width: 1) : Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          color: Colors.transparent
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        child:  Row(
          children: [
            FaIcon(icons[i], size: 15, color: (i==current) ? Colors.orange:Colors.black,),
            Container(width: 10,),
            Text(item, style: TextStyle(fontSize: 13, color: (i==current) ? Colors.orange:Colors.black,),)
          ],
        ));
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

