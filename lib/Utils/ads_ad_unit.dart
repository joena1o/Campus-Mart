import 'package:flutter_dotenv/flutter_dotenv.dart';

String bannerAdUnit = dotenv.env['BANNER_AD']!;
String interstitialAdUnit = dotenv.env['INTERSTITIAL_AD']!;
String rewardAdUnit = dotenv.env['REWARDING_AD']!;

String iOSBannerAdUnit = dotenv.env['IOS_BANNER_AD']!;