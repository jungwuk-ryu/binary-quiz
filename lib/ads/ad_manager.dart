import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class ADManager {
  static late ADManager instance;
  String getInterstitialAdUnitId();

  // From https://github.com/deniza/app_tracking_transparency/issues/47#issuecomment-1751719988
  Future<String?> trackingTransparencyRequest() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (Platform.isIOS &&
        int.parse(Platform.operatingSystemVersion.split(' ')[1].split('.')[0]) >=
            14) {
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.authorized) {
        final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
        return uuid;
      } else if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
        final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
        return uuid;
      }
    }

    return null;
  }

  Future<void> showInterstitialAd() async {
    InterstitialAd? interstitialAd;
    String adUnitId = getInterstitialAdUnitId();

    await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
            interstitialAd?.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }
}