import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sun_be_gone/utils/logger.dart';

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
      logger.i('Ad loaded: ${ad.adUnitId}.');
    },
    onAdFailedToLoad: (ad, error) {
      logger.i('Ad failed to load: ${ad.adUnitId}, $error.');
      ad.dispose();
    },
    onAdOpened: (ad) => logger.i('Ad opened: ${ad.adUnitId}.'),
    onAdClosed: (ad) => logger.i('Ad closed: ${ad.adUnitId}.'),
    onAdWillDismissScreen: (ad) =>
        logger.i('Ad will dismiss screen: ${ad.adUnitId}.'),
    onAdImpression: (ad) => logger.i('Ad impression: ${ad.adUnitId}.'),
    onPaidEvent: (ad, value, precision, currencyCode) => logger
        .i('Paid event: ${ad.adUnitId}, $value, $precision, $currencyCode.'),
    onAdClicked: (ad) => logger.i('Ad clicked: ${ad.adUnitId}.'),
  );
}
