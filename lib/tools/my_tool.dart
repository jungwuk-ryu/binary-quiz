import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyTool {
  static SnackbarController? _snackbarController;

  static Future<void> snackbar({String? title, String? body}) async {
    await closeSnackbar(animation: false);
    _snackbarController = Get.snackbar(title ?? "", body ?? "",
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w));
  }

  static Future<void> closeSnackbar({bool animation = true}) async {
    try {
      await _snackbarController?.close(withAnimations: animation);
    } catch (_) {}
  }
}
