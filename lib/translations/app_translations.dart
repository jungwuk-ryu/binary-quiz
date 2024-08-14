import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static late Map<String, String> enUS;
  static late Map<String, String> koKR;
  static late Map<String, String> jaJP;
  static late Map<String, String> zhCN;
  static late Map<String, String> hiIN;
  static late Map<String, String> esES;
  static late Map<String, String> esLA;
  static late Map<String, String> ruRU;
  static late Map<String, String> deDE;

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ko_KR': koKR,
    'ja_JP': jaJP,
    'zh_CN': zhCN,
    'hi_IN': hiIN,
    'es_ES': esES,
    'es_LA': esLA,
    'ru_RU': ruRU,
    'de_DE': deDE
  };

  static Future<void> load() async {
    debugPrint("load translations...");
    int l1 = DateTime.now().millisecondsSinceEpoch;

    enUS = await loadJson('assets/lang/en_US.json');
    koKR = await loadJson('assets/lang/ko_KR.json');
    jaJP = await loadJson('assets/lang/ja_JP.json');
    zhCN = await loadJson('assets/lang/zh_CN.json');
    hiIN = await loadJson('assets/lang/hi_IN.json');
    esES = await loadJson('assets/lang/es_ES.json');
    esLA = await loadJson('assets/lang/es_LA.json');
    ruRU = await loadJson('assets/lang/ru_RU.json');
    deDE = await loadJson('assets/lang/de_DE.json');

    debugPrint("translations loaded in ${DateTime.now().millisecondsSinceEpoch - l1}ms");
  }

  static Future<Map<String, String>> loadJson(String path) async {
    String jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }
}