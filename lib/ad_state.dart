import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8971859503882646/6202513519';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  BannerAdListener get bannerAdListener => _bannerAdListener;

  final BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) {
      print('Ad loaded: ${ad.adUnitId}.');
    },
    onAdFailedToLoad: (ad, error) {
      print('Ad failed to load: ${ad.adUnitId}, $error.');
      ad.dispose();
    },
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdWillDismissScreen: (ad) =>
        print('Ad will dismiss screen: ${ad.adUnitId}.'),
    onAdImpression: (ad) => print('Ad impression: ${ad.adUnitId}.'),
    onPaidEvent: (ad, value, precision, currencyCode) =>
        print('Paid event: ${ad.adUnitId}, $value, $precision, $currencyCode.'),
    onAdClicked: (ad) => print('Ad clicked: ${ad.adUnitId}.'),
  );
}

