import 'dart:io';
import 'dart:ui';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'translations/app_translations.dart';
import 'ui/themes/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
    await _trackingTransparencyRequest();
    _showInterstitialAd();
  });
  MobileAds.instance.initialize();

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    SharedPreferences.getInstance(),
    AppTranslations.load()
  ]);

  // Firebase Crashlytics - 비정상 종료 핸들러 구성
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(colorSchemeSeed: AppColors.primary),
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            translations: AppTranslations(),
            fallbackLocale: const Locale('en', 'US'),
            locale: Get.deviceLocale,
          );
        });
  }
}

// From https://github.com/deniza/app_tracking_transparency/issues/47#issuecomment-1751719988
Future<String?> _trackingTransparencyRequest() async {
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

Future<void> _showInterstitialAd() async {
  InterstitialAd? interstitialAd;

  late String adUnitId;
  if (kDebugMode) {
    adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910';
  } else {
    adUnitId = Platform.isAndroid
        ? throw UnimplementedError()
        : 'ca-app-pub-3321763933554531/4969851808';
  }

  await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
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