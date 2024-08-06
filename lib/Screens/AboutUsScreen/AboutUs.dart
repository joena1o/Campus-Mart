import 'dart:io';
import 'package:campus_mart/Utils/ads_ad_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}


class _AboutUsState extends State<AboutUs> {
  String fileContent = "";

  Future<void> loadFile() async {
    String content = await rootBundle.loadString('assets/about_us.txt');
    setState(() {
      fileContent = content;
    });
  }
  InterstitialAd? _interstitialAd;

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    loadFile();
    loadAd();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "About Us",
            style: TextStyle(fontSize: 15),
          ),
          elevation: 0,
        ),
        body: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: size.height,
          child: SingleChildScrollView(child:Text(fileContent, style: const TextStyle(fontSize: 15),)),
        ),
      ),
    );
  }

  void loadAd() {
    InterstitialAd.load(
        adUnitId: interstitialAdUnit,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            setState((){
              _interstitialAd = ad;
            });
            _interstitialAd?.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

}
