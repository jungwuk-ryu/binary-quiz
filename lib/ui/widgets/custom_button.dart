import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../themes/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function? onClick;
  final RxBool _isLoading = RxBool(false);

  CustomButton({super.key, this.text = "", this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40.h,
        padding: EdgeInsets.symmetric(vertical: 9.5.h, horizontal: 9.5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.primary,
        ),
        child: Center(
          child: Obx(() {
            if (_isLoading.isTrue) {
              return const CircularProgressIndicator();
            } else {
              return Text(text,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.spMin,
                      color: AppColors.textWhite));
            }
          }),
        ),
      ),
    );
  }

  void onTap() async {
    if (onClick == null) return;

    if (_isLoading.isTrue) return;
    _isLoading.value = true;

    try {
      var ret = onClick!.call();
      if (ret is Future) await ret;
    } catch (e, st) {
      log(e.toString());
      debugPrintStack(stackTrace: st);
    }

    _isLoading.value = false;
  }
}
