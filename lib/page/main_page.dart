import 'package:binary_quiz/controller/main_page_controller.dart';
import 'package:binary_quiz/game/game.dart';
import 'package:binary_quiz/game/game_bin_to_dec.dart';
import 'package:binary_quiz/tool/my_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../app_colors.dart';
import '../routes/app_pages.dart';
import '../widget/border_container.dart';
import '../widget/custom_button.dart';
import '../widget/title_text.dart';

class MainPage extends GetView<MainPageController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText("Binary Quiz"),
              SizedBox(height: 12.h),
              Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                            const BorderContainer(
                                title: "📖 앱 설명",
                                body:
                                "Binary Quiz는 이진수 계산 능력을 향상시킬 수 있는 앱입니다.\n반복 연습을 통해 당신의 계산 속도를 향상시켜보세요!"),
                            SizedBox(height: 20.h),
                            const BorderContainer(
                                title: "🕹️ 퀴즈",
                                body: "즐기고 싶은 퀴즈를 선택하세요",
                                backgroundColor: AppColors.grey),
                            _SelectableBorderContainer(GameBinToDec(0)),
                          ])),
                    ],
                  )),
              SizedBox(height: 12.h),
              CustomButton(text: "선택했어요", onClick: _onButtonClick),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonClick() {
    if (!controller.hasSelectedGame()) {
      MyTool.snackbar(title: "게임을 선택해주세요");
      return;
    }

    Get.toNamed(Routes.LOBBY);
  }
}

class _SelectableBorderContainer extends GetView<MainPageController> {
  final Game game;
  final RxBool isSelected = RxBool(false);

  _SelectableBorderContainer(this.game) {
    isSelected.listen((p0) {
      if (p0 == false) {
        controller.unselectGameByGame(game);
      } else {
        controller.selectedGame(game);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child:
          BorderContainer(
            title: game.getName(),
            body: game.getDescription(),
            checkBox: isSelected,
          ),
    );
  }

  void _onTap() {
    controller.setSelectedGame(game);
    isSelected.value = controller.isSelected(game);
  }
}