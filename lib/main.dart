import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads/ad_manager.dart';
import 'secrets/my_ad_manager.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'translations/app_translations.dart';
import 'ui/themes/app_colors.dart';

void main() async {
  ADManager adManager = MyADManager();
  ADManager.instance = adManager; // 작성하신 ADManager 클래스로 수정하십시오.

  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) async {
    await adManager.trackingTransparencyRequest();
    adManager.showInterstitialAd();
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