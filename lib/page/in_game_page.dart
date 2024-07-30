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
import '../widget/custom_keypad.dart';

class InGamePage extends GetView<InGameController> {
  final Color _textFieldDefaultColor = AppColors.grey;
  final Rx<Color> _textFieldColor = AppColors.grey.obs;
  Timer? _textFieldTimer;

  InGamePage({super.key}) {
    controller.setOnPassListener(() => _onPass());
    controller.setOnFailListener(() => _onFail());
  }

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
                  fontSize: 22.spMin,
                  color: AppColors.text)),
          const Expanded(child: SizedBox()),
          const ExitButton()
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
                          fontSize: 22.spMin,
                          color: AppColors.text),
                      children: [
                        TextSpan(text: controller.getQuestion()),
                        TextSpan(
                            text: "(2) ",
                            style: TextStyle(
                                color: AppColors.textBlueGrey,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.spMin)),
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
                            fontSize: 20.spMin, fontWeight: FontWeight.bold),
                        autofocus: !(Platform.isAndroid || Platform.isIOS),
                        onTapOutside: (event) =>
                            FocusScope.of(Get.context!).unfocus(),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        onEditingComplete: () {},
                        onSubmitted: (value) => checkAnswer(),
                        inputFormatters: [
                          if (controller.game.textInputFormatter != null)
                            controller.game.textInputFormatter!,
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


  void _onPass() {
    _setColor(const Color(0xFFC9FFBA));
    controller.nextGame();
  }

  void _onFail() {
    _setColor(const Color(0xFFFFB5B5));
  }

  void checkAnswer() {
    controller.check(true);
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
              duration: const Duration(milliseconds: 500),
            );
          }),
        )
      ],
    );
  }
}
