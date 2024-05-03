import 'package:campus_mart/Utils/adsAdUnit.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider extends ChangeNotifier {
  BannerAd? _bannerAd;

  BannerAd get bannerAd => _bannerAd ?? BannerAd(
    adUnitId: bannerAdUnit,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

    void loadAd() {
    _bannerAd?.dispose(); // Dispose of the previous ad if it exists
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    )..load();
    notifyListeners();
  }
}
