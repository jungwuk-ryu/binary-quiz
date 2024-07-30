import 'package:binary_quiz/app_colors.dart';
import 'package:binary_quiz/widget/exit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/game_lobby_controller.dart';
import '../widget/border_container.dart';
import '../widget/custom_button.dart';
import '../widget/title_text.dart';

class GameLobbyPage extends GetView<GameLobbyController> {
  const GameLobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                children: [
                  TitleText("Binary Quiz"),
                  Expanded(child: SizedBox()),
                  ExitButton(),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                  child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    BorderContainer(
                        title: "📖 ${controller.getGame().getName()}",
                        body:
                            controller.getGame().getDescription()),
                    SizedBox(height: 20.h)
                  ])),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const Expanded(child: SizedBox()),
                        const BorderContainer(
                            title: "⚙️ 설정",
                            body: "게임을 커스터마이징 해요",
                            backgroundColor: AppColors.grey),
                        BorderContainer(
                          title: "라운드",
                          body: "최대 라운드 수를 지정합니다",
                          textEditingController:
                              controller.maxRoundsEditingController,
                          keyboard: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          textFieldHint: "라운드 수 (정수)",
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        BorderContainer(
                            title: "자동 제출",
                            body: "정답을 입력할 경우 자동으로 다음으로 넘어갑니다.",
                            checkBox: controller.getGameSettings().autoSubmit),
                        BorderContainer(
                            title: "소리 재생",
                            body: "퀴즈 정답 여부에 따른 효과음을 재생합니다",
                            checkBox: controller.getGameSettings().soundEnabled),
                      ],
                    ),
                  ),
                ],
              )),
              SizedBox(height: 12.h),
              CustomButton(text: "시작", onClick: controller.startGame),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
