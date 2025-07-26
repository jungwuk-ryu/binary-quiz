import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../ui/themes/app_colors.dart';
import '../../../ui/widgets/custom_button.dart';
import '../../../ui/widgets/custom_keypad.dart';
import '../../../ui/widgets/exit_button.dart';
import '../../../ui/widgets/title_text.dart';
import '../controllers/in_game_controller.dart';

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
          TitleText("module.in_game.title".tr),
          const Expanded(child: SizedBox()),
          const ExitButton()
        ]),
        SizedBox(height: 20.h),
        _getProgressBar(),
        SizedBox(height: 20.h),
        Center(
          child: Obx(
            () => RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.spMin,
                      color: AppColors.text),
                  children: [
                    TextSpan(text: "${controller.getQuestion()}"),
                    TextSpan(
                        text: " ${controller.game.getQuestionSuffix()}",
                        style: TextStyle(
                            color: AppColors.textBlueGrey,
                            fontWeight: FontWeight.normal,
                            fontSize: 13.spMin)),
                    //const TextSpan(text: "= ")
                  ],
                )),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 50.h,
          child: Obx(() => AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
            decoration: BoxDecoration(
              color: _textFieldColor.value,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: TextField(
                  controller: controller.teController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: "module.in_game.enter_answer".tr),
                  style: TextStyle(
                      fontSize: 20.spMin, fontWeight: FontWeight.bold),
                  autofocus: kIsWeb || !(Platform.isAndroid || Platform.isIOS),
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
            ),
          )),
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
            text: "module.in_game.entered_answer".tr,
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
