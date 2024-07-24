import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:binary_quiz/controller/in_game_controller.dart';
import 'package:binary_quiz/widget/custom_button.dart';
import 'package:binary_quiz/widget/exit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../app_colors.dart';
import '../widget/CustomKeypad.dart';

class InGamePage extends StatelessWidget {
  final InGameController controller;
  final Color _textFieldDefaultColor = AppColors.grey;
  final Rx<Color> _textFieldColor = AppColors.grey.obs;
  Timer? _textFieldTimer;

  InGamePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          child: _getBodyWidget(),
        ),
      ),
    );
  }

  Widget _getBodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text("퀴즈",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                  color: AppColors.text)),
          Expanded(child: SizedBox()),
          ExitButton()
        ]),
        SizedBox(height: 20.h),
        _getProgressBar(),
        SizedBox(height: 20.h),
        Row(
          children: [
            Obx(
              () => Center(
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                          color: AppColors.text),
                      children: [
                        TextSpan(text: controller.getCurrentBinary()),
                        TextSpan(
                            text: "(2) ",
                            style: TextStyle(
                                color: AppColors.textBlueGrey,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.sp)),
                        const TextSpan(text: "= ")
                      ],
                    )),
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
                child: SizedBox(
              height: 50.h,
              child: Obx(() => AnimatedContainer(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    decoration: BoxDecoration(
                      color: _textFieldColor.value,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                        controller: controller.teController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: "정답 입력"),
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                        autofocus: !(Platform.isAndroid || Platform.isIOS),
                        onTapOutside: (event) =>
                            FocusScope.of(Get.context!).unfocus(),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        onEditingComplete: () {},
                        onSubmitted: (value) => checkAnswer(),
                        inputFormatters: [
                          if (controller.textInputFormatter != null)
                            controller.textInputFormatter!,
                        ]),
                  )),
            ))
          ],
        ),
        const Expanded(child: SizedBox()),
        SizedBox(
            height: min(400, 400.h),
            child: CustomKeypad(
              numbers: const [7, 8, 9, 4, 5, 6, 1, 2, 3],
              sign: true,
              dot: true,
              onPressed: controller.handleKeypadInput,
            )),
        SizedBox(height: 20.h),
        CustomButton(
            text: "입력 완료",
            onClick: () {
              checkAnswer();
            })
      ],
    );
  }

  void checkAnswer() {
    bool? ret = controller.check();
    if (ret == null) {
      _setColor(const Color(0xFFFFB5B5));
    } else if (ret) {
      _setColor(const Color(0xFFC9FFBA));
      controller.onPass();
    } else {
      _setColor(const Color(0xFFFFB5B5));
      controller.onNonPass();
    }
  }

  void _setColor(Color color) {
    if (_textFieldTimer != null) {
      if (_textFieldTimer!.isActive) _textFieldTimer!.cancel();
      _textFieldTimer = null;
    }
    _textFieldColor.value = color;
    _textFieldTimer = Timer(const Duration(milliseconds: 400), () {
      _textFieldColor.value = _textFieldDefaultColor;
    });
  }

  Widget _getProgressBar() {
    return Stack(
      children: [
        Container(
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.grey,
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Obx(() {
            return AnimatedContainer(
              height: 8.h,
              width: constraints.maxWidth *
                  (controller.getCurrentRounds() / controller.getMaxRounds()),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: AppColors.black,
              ),
              duration: Duration(milliseconds: 500),
            );
          }),
        )
      ],
    );
  }
}
