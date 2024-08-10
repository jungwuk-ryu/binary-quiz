import 'package:binary_quiz/ui/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../ui/widgets/exit_button.dart';
import '../controllers/game_lobby_controller.dart';
import '../../../ui/widgets/border_container.dart';
import '../../../ui/widgets/custom_button.dart';
import '../../../ui/widgets/title_text.dart';

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
                        ...controller.getGame().getSettingWidgets()
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
