import 'package:campus_mart/Utils/ads_ad_unit.dart';
import 'package:campus_mart/screens/feed_back_screen/feed_back_page/widget/bug.dart';
import 'package:campus_mart/screens/feed_back_screen/feed_back_page/widget/feed_back_card.dart';
import 'package:campus_mart/screens/feed_back_screen/feed_back_page/widget/report.dart';
import 'package:campus_mart/screens/feed_back_screen/feed_back_page/widget/suggest.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute ;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';


class FeedbackView extends StatefulWidget {
  const FeedbackView({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn);

    _controller!.forward();

    loadAd();

  }

  int step = 2;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
              width: size.width,
              height: size.height,
              child: FadeTransition(
                opacity: _animation!,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
          
                    Container(height: 30,),
          
                    step == 1
                        ? Report(feedBackType: widget.type)
                        : GestureDetector(
                            onTap: () {
                              setState(() => step = 1);
                            },
                            child: const FeedbackCard(
                                title: "Report an issue with the transaction")),
                    20.height,
                    step == 2
                        ? Suggest(feedBackType: widget.type)
                        : GestureDetector(
                            onTap: () {
                              setState(() => step = 2);
                            },
                            child:
                                const FeedbackCard(title: "Suggest a new feature")),
                    20.height,
                    step == 3
                        ? Bug(feedBackType: widget.type)
                        : GestureDetector(
                            onTap: () {
                              setState(() => step = 3);
                            },
                            child: const FeedbackCard(title: "Report Bug")),
          
          
                   const Spacer(),
          
                    _bannerAd == null
                        ? const SizedBox() : SizedBox(
                        height: 50,
                        child: AdWidget(ad: _bannerAd!)),
          
                    const SizedBox(height: 10,)
          
                  ],
                ),
              )),
        ));
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

